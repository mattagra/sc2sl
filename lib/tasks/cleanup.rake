namespace 'cleanup' do

  desc "Clean up Active Record sessions updated over ENV['EXPIRE_AT'] (defaults to 36 hours ago)."
  task :clean_ar_sessions => :environment do 
    time = ENV['EXPIRE_AT'] || 36.hours.ago.to_s(:db)
    rows = ActiveRecord::SessionStore::Session.delete_all(["updated_at < ?", time])
    RAILS_DEFAULT_LOGGER.info "#{rows} session row(s) deleted."
  end
  
end