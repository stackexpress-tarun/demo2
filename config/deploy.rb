# config valid only for Capistrano 3.1
lock '3.2.1'
# Automatically precompile assets
# load "deploy/assets"
 

set :default_stage, 'production'
set :stages, %w(production staging)

# server name for nginx, default value: "localhost <application>.local"
# set this to your site name as it is visible from outside
# this will allow 1 nginx to serve several sites with different `server_name`
set :nginx_server_name, "127.0.0.1:8080"
# require 'capistrano/ext/multistage'
# require 'bundler/capistrano'

# path, where nginx pid file will be stored (used in logrotate recipe)
# default value: `"/run/nginx.pid"`
set :nginx_pid, "/tmp/nginx.pid"

# if set, nginx will be configured to 443 port and port 80 will be auto rewritten to 443
# also, on `nginx:setup`, paths to ssl certificate and key will be configured
# and certificate file and key will be copied to `/etc/ssl/certs` and `/etc/ssl/private/` directories
# default value: false
set :nginx_use_ssl, false

# nginx config file location
# centos users can set `/etc/nginx/conf.d`
# default value: `/etc/nginx/sites-available`
set :nginx_config_path, "/home/vagrant/app/demo2"

# path, where unicorn pid file will be stored
# default value: `"#{current_path}/tmp/pids/unicorn.pid"`
set :unicorn_pid, "#{nginx_config_path}/tmp/pids/unicorn.pid"

# path, where unicorn config file will be stored
# default value: `"#{shared_path}/config/unicorn.rb"`
set :unicorn_config, "#{nginx_config_path}/config/unicorn.rb"

# path, where unicorn log file will be stored
# default value: `"#{shared_path}/config/unicorn.rb"`
set :unicorn_log, "#{nginx_config_path}/config/unicorn.rb"

# user name to run unicorn
# default value: `user` (user varibale defined in your `deploy.rb`)
set :unicorn_user, "vagrant"

# number of unicorn workers
# default value: 2
set :unicorn_workers, 2


set :application, "demo2"
# set :repository
set :repo_url, "git@github.com:stackexpress-tarun/demo2.git"
set :deploy_to, '/home/vagrant/app/demo2'
set :scm, :git
set :branch, 'master'
set :user, 'vagrant'
# set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
set :deploy_via, :copy
set :keep_releases, 5
set :use_sudo, false
set :rails_env,       "production"

# set :ssh_options, {:forward_agent => true}
role :web, "192.168.33.10"                          # Your HTTP server, Apache/etc
role :app, "192.168.33.10"                          # This may be the same as your `Web` server
# role :db,  "192.168.10.22", :primary => true

# default_run_options[:shell] = 'bash'

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  # %w[start stop restart].each do |command|
  #   desc "#{command} unicorn server"
  #   task command, roles: :app, except: { no_release: true } do
  #     run "/etc/init.d/unicorn_#{application} #{command}"
  #   end
  # end

  # task :setup_config, roles: :app do
  #   # symlink the unicorn init file in /etc/init.d/
  #   sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  #   # create a shared directory to keep files that are not in git and that are used for the application
  #   run "mkdir -p #{shared_path}/config"
  #   # if you're using mongoid, create a mongoid.template.yml file and fill it with your production configuration
  #   # and add your mongoid.yml file to .gitignore
  #   puts "Now edit the config files in #{shared_path}."
  # end

  #  after "deploy:setup", "deploy:setup_config"


#   desc "symlink shared files"
#   task :symlink_shared, :roles => :app do
#     run "ln -nfs #{shared_path}/system/mongoid.yml #{release_path}/config/mongoid.yml"
#     run "ln -nfs #{shared_path}/system/application.yml #{release_path}/config/application.yml"
#   end

#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end

end

# before "deploy:assets:precompile", "deploy:symlink_shared"

# Unicorn
# require 'capistrano-unicorn'
# after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
# after 'deploy:restart', 'unicorn:restart'   # app preloaded


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
