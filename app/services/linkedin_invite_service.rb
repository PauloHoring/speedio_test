# frozen_string_literal: true

class LinkedinInviteService
  def initialize(company, params)
    @company = company
    @params = params
  end

  def process
    update_company_decisor
    create_automation
  end

  private

  def update_company_decisor
    @company.decisor ||= {}
    @company.decisor['linkedin_url'] = @params[:profile_url]
    @company.save
  end

  def create_automation
    automation = @company.automations.new(
      programmed_to: @params[:programmed_to],
      type: 'linkedin_connection'
    )

    if automation.save
      LinkedinConnectionJob.set(wait_until: @params[:programmed_to]).perform_later(automation.id.to_s)
      OpenStruct.new(success?: true, message: 'Linkedin invite scheduled successfully')
    else
      OpenStruct.new(success?: false, error: 'Failed to create automation', details: automation.errors)
    end
  end
end
