# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 6.hours do
  rake "cleanup:clean_ar_sessions"
end

every 1.hour do
  rake "cleanup:clean_users"
end


job_type :envcommand, 'cd :path && RAILS_ENV=:environment :task'

every :reboot do
  envcommand 'script/delayed_job restart'
end

