include_recipe "php"
include_recipe "php-fpm"
include_recipe "nginx"

package "ruby"
package "ffmpeg"

gem_package "compass"
gem_package "zurb-foundation" do
  version "3.2.5"
end

link "/etc/php5/conf.d/20-mongo.ini" do
  to "/etc/php5/mods-available/mongo.ini"
end

template "/etc/php5/fpm/pool.d/www.conf" do
  source "www.conf.erb"
  variables(
    :max_upload_size => node["skveez_application"]["max_upload_size"],
    :memory_limit => node["skveez_application"]["memory_limit"]
  )
  notifies :restart, "service[php5-fpm]"
end

application_settings = data_bag_item("skveez", "application")
database_node = search(:node, "role:skveez_database").first
sessions_node = search(:node, "role:skveez_sessions").first
search_node = search(:node, "role:skveez_search").first

application "skveez" do
  path "/var/www"
  owner "www-data"
  repository "git@github.com:rithis/skveez.git"
  revision "master"
  deploy_key application_settings["deploy_key"]
  environment "SYMFONY_ENV" => "prod", "HOME" => "/var/www"
  purge_before_symlink ["app/logs", "web/uploads"]
  symlinks(
    "logs" => "app/logs",
    "uploads" => "web/uploads"
  )
  symlink_before_migrate(
    "parameters.yml" => "app/config/parameters.yml"
  )
  migrate true
  migration_command "./migration.sh"

  before_migrate do
    template "/var/www/shared/parameters.yml" do
      source "parameters.yml.erb"
      owner "www-data"
      variables(
        :application_settings => application_settings,
        :database_node => database_node,
        :sessions_node => sessions_node,
        :search_node => search_node
      )
    end
  end

  before_symlink do
    directory "/var/www/shared/logs" do
      owner "www-data"
      recursive true
    end

    directory "/var/www/shared/uploads" do
      owner "www-data"
    end
  end

  action ::File.exists?("/var/www/current") ? :deploy : :force_deploy
end


template "#{node["nginx"]["dir"]}/sites-available/skveez.com" do
  source "skveez.com.erb"
  variables :max_upload_size => node["skveez_application"]["max_upload_size"]
  notifies :reload, "service[nginx]"
end

nginx_site "skveez.com"
