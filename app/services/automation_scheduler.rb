# frozen_string_literal: true

class AutomationScheduler
  def self.run
    current_time = Time.current

    start_of_minute = current_time.beginning_of_minute
    end_of_minute = current_time.end_of_minute

    automations = Automation.where(programmed_to: start_of_minute..end_of_minute)

    automations.each do |automation|
      process_automation(automation)
    end
  end

  def self.process_automation(automation)
    case automation.type
    when 'email'
      EmailJob.perform_now(automation.id.to_s)
    when 'linkedin_message'
      LinkedinMessageJob.perform_now(automation.id.to_s)
    when 'linkedin_connection'
      LinkedinConnectionJob.perform_now(automation.id.to_s)
    else
      puts "Unknown automation type: #{automation.type}"
    end
  end
end
