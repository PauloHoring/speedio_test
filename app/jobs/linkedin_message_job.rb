# frozen_string_literal: true

class LinkedinMessageJob < ApplicationJob
  queue_as :default

  def perform(automation_id)
    automation = Automation.find(automation_id)
    user = automation.company.user

    response = UnipileService.send_linkedin_message(
      user.unipile_linkedin_account_id,
      automation.company.decisor['linkedin_url'],
      automation.message
    )

    return unless response.success?

    automation.update(sent_at: Time.current)
  end
end
