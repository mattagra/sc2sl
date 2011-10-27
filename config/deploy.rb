set :application, "sc2sl"
set :domain,      "vps13407.ovh.net"
set :repository,  "git@github.com:turlockmike/sc2sl.git"
set :deploy_to,   "/apps/#{application}"
set :branch, "master"
set :scm, "git"
set :scm_verbose, true
set :user, "root"

set :default_environment, {
  'PATH' => "/var/lib/gems/1.8/bin:$PATH"
}

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
set :bundle_flags, "--quiet"

require 'bundler/capistrano'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
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

after 'deploy:update_code', 'deploy:symlink_shared'
after "deploy:restart", "delayed_job:restart"
