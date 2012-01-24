default_run_options[:pty] = true
set :application, "sc2sl"
set :domain,      "vps13407.ovh.net"
set :repository,  "git@github.com:turlockmike/sc2sl.git"
set :deploy_to,   "/apps/#{application}"
set :branch, "master"
set :scm, "git"
set :scm_verbose, true
set :user, "root"
set :password, "MAzrdNzV"

set :default_environment, {
  'PATH' => "/var/lib/gems/1.8/bin:$PATH"
}

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
set :bundle_flags , "--quiet"

require 'bundler/capistrano'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  namespace :web do
    desc <<-DESC
      Present a maintenance page to visitors. Disables your application's web \
      interface by writing a "maintenance.html" file to each web server. The \
      servers must be configured to detect the presence of this file, and if \
      it is present, always display it instead of performing the request.

      By default, the maintenance page will just say the site is down for \
      "maintenance", and will be back "shortly", but you can customize the \
      page by specifying the REASON and UNTIL environment variables:

        $ cap deploy:web:disable \\
              REASON="a hardware upgrade" \\
              UNTIL="12pm Central Time"

      Further customization will require that you write your own task.
    DESC
    task :disable, :roles => :web do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason = ENV['REASON'] || "maintenance"
      deadline = ENV['UNTIL']
      template = File.read('app/views/layouts/maintenance.html.erb')
      page = ERB.new(template).result(binding)

      put page, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
  
  
  
  
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
   
  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/public/shared #{release_path}/public/shared"
  end



 end

namespace :delayed_job do
    desc "Restart the delayed_job process"
    task :restart, :roles => :app do

        run "cd #{current_path};chmod 755 script/delayed_job;RAILS_ENV=#{rails_env} script/delayed_job restart"
    end
end

namespace :memcached do 
    desc "Start memcached"
    task :start, :roles => :app  do
      sudo "/etc/init.d/memcached start"
    end
    desc "Stop memcached"
    task :stop, :roles => :app  do
      sudo "/etc/init.d/memcached stop"
    end
    desc "Restart memcached"
    task :restart, :roles => :app  do
      sudo "/etc/init.d/memcached restart"
    end        
    desc "Flush memcached - this assumes memcached is on port 11211"
    task :flush, :roles => :app  do
      sudo "echo 'flush_all' | nc localhost 11211"
    end        
  end



after 'deploy:update_code', 'deploy:symlink_shared'
#after 'deploy:restart', 'delayed_job:restart'
#after 'delayed_job:restart', 'memcached:restart'
#after 'memcached:restart', 'deploy:web:enable'
