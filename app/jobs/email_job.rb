# frozen_string_literal: true

class EmailJob < ApplicationJob
  queue_as :default

  def perform(automation_id)
    automation = Automation.find(automation_id)
    user = automation.company.user

    response = UnipileService.send_email(
      user.unipile_email_account_id,
      automation.company.decisor['email'],
      automation.message
    )

    return unless response.success?

    automation.update(sent_at: Time.current)
  end
end
