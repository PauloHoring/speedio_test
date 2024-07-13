# frozen_string_literal: true

class LinkedinConnectionJob < ApplicationJob
  queue_as :default

  def perform(automation_id)
    automation = Automation.find(automation_id)
    user = automation.company.user

    response = UnipileService.send_linkedin_connection(
      user.unipile_linkedin_account_id,
      automation.company.decisor['linkedin_url']
    )

    if response.success?
      automation.update(sent_at: Time.current)
    else
      automation
    end
  end
end
