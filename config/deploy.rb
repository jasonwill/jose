ssh_options[:forward_agent] = true
  
require "rvm/capistrano"

set :rvm_ruby_string, '1.9.3-p194'
set :rvm_type, :user

# bundler bootstrap
require 'bundler/capistrano'

# main details
set :application, "jose"
role :web, "x"
role :app, "x"
role :db,  "x", :primary => true

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/var/www/rails/jose"
set :deploy_via, :remote_cache
set :user, "webeditor"
set :use_sudo, false

# repo details
set :scm, :git
set :repository, "git@github.com:jasonwill/jose.git"
set :branch, "master"
set :git_enable_submodules, 1

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end