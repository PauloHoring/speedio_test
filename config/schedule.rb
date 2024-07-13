# frozen_string_literal: true

set :output, 'log/cron_log.log'
env :PATH, ENV['PATH']

every 1.minute do
  runner 'AutomationScheduler.run', environment: 'development'
end
