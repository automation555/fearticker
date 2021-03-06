set :application, "fearticker"
set :hostname, "www.fearticker.com"

set :user, "deploy"
set :host, "#{user}@#{hostname}"

set :scm, :git
set :repository, "git@github.com:nimbletechnique/#{application}.git"
set :use_sudo, false

set :deploy_to, "/var/www/apps/#{application}"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :runner, user
set :ssh_options, { :forward_agent => true }
set :branch, "master"

role :app, "#{host}"
role :web, "#{host}"
role :db,  "#{host}", :primary => true


namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after 'deploy:update_code' do
  ["database", "mongrel_cluster"].each do |name|
    run "cp #{deploy_to}/shared/#{name}.yml #{release_path}/config"
  end
end
