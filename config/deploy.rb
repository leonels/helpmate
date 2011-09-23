set :application, "helpmate"
set :repository,  "tallercreativo@ubuntu:git/helpmate.git"

set :scm, :git

set :user, 'root'
set :user_sudo, false
set :deploy_to, "/srv/www/helpmateapp.com/#{application}"
set :deploy_via, :remote_cache


role :web, "helpmateapp.com"                          # Your HTTP server, Apache/etc
role :app, "helpmateapp.com"                          # This may be the same as your `Web` server
role :db,  "helpmateapp.com", :primary => true # This is where Rails migrations will run

after "deploy", "deploy:restart"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    # run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
