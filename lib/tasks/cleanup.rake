namespace 'cleanup' do

  desc "Clean up Active Record sessions updated over ENV['EXPIRE_AT'] (defaults to 36 hours ago)."
  task :clean_ar_sessions => :environment do 
    time = ENV['EXPIRE_AT'] || 36.hours.ago.to_s(:db)
    rows = ActiveRecord::SessionStore::Session.delete_all(["updated_at < ?", time])
    RAILS_DEFAULT_LOGGER.info "#{rows} session row(s) deleted."
  end
  
  desc "delete old users and send reactivation emails to users at certain timeframes."
  task :clean_users => :environment do
    User.inactive.where(:created_at.lt => 30.days.ago ).delete_all 
    User.inactive.where(:created_at.gt => 24.hours.ago, :created_at.lt => 23.hours.ago).each do |user|
      user.send_on_create_confirmation_instructions
    end
    User.inactive.where(:created_at.gt => 72.hours.ago, :created_at.lt => 71.hours.ago).each do |user|
      user.send_on_create_confirmation_instructions
    end
  end
  
  
end