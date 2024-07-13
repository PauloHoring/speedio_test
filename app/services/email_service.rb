# frozen_string_literal: true

class EmailService
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
    @company.decisor['email'] = @params[:to]
    @company.save
  end

  def create_automation
    automation = @company.automations.new(
      type: 'email',
      message: @params[:message],
      programmed_to: @params[:programmed_to]
    )

    if automation.save
      EmailJob.set(wait_until: @params[:programmed_to]).perform_later(automation.id.to_s)
      OpenStruct.new(success?: true, message: 'Email scheduled successfully')
    else
      OpenStruct.new(success?: false, error: 'Failed to create automation', details: automation.errors)
    end
  end
end
