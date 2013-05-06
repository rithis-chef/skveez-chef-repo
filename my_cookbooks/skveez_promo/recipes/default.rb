include_recipe "mysql::server"
include_recipe "database::mysql"
include_recipe "php"
include_recipe "php-fpm"
include_recipe "nginx"

package "php5-mysql"
package "php5-gd"

node.set_unless['skveez_promo']['database']['database'] = "skveez_promo"
node.set_unless['skveez_promo']['database']['username'] = "skveez_promo"
node.set_unless['skveez_promo']['database']['password'] = secure_password
node.set_unless['skveez_promo']['session_secret'] = secure_password

connection_info = {
  :host => "localhost",
  :port => node['mysql']['port'],
  :username => "root",
  :password => node['mysql']['server_root_password']
}

mysql_database node['skveez_promo']['database']['database'] do
  connection connection_info
end

mysql_database_user node['skveez_promo']['database']['username'] do
  password node['skveez_promo']['database']['password']
  database_name node['skveez_promo']['database']['database']
  connection connection_info
  host "localhost"
  action [:create, :grant]
end

execute "populate database" do
  command <<-EOS
    mysql \
      -u#{node['skveez_promo']['database']['username']} \
      -p#{node['skveez_promo']['database']['password']} \
      #{node['skveez_promo']['database']['database']} \
      < /var/www/current/db.sql
  EOS

  not_if <<-EOS
    mysql \
      -u#{node['skveez_promo']['database']['username']} \
      -p#{node['skveez_promo']['database']['password']} \
      #{node['skveez_promo']['database']['database']} \
      -e "show tables" | grep "skveez_"
  EOS
end

template "/etc/php5/fpm/pools/www.conf" do
  source "www.conf.erb"
  variables(
    :max_upload_size => node['skveez_promo']['max_upload_size'],
    :memory_limit => node['skveez_promo']['php']['memory_limit']
  )
  notifies :restart, "service[php-fpm]"
end

application "skveez_promo" do
  path "/var/www"
  owner "www-data"
  repository "git://github.com/smart5fun/SkveezPromoSite.git"
  revision "master"
  symlinks "config.inc.php" => "manager/includes/config.inc.php"

  before_symlink do
    template "/var/www/shared/config.inc.php" do
      source "config.inc.php.erb"
      owner "www-data"
      variables(
        :database_host => "localhost",
        :database_username => node['skveez_promo']['database']['username'],
        :database_password => node['skveez_promo']['database']['password'],
        :database_name => node['skveez_promo']['database']['database'],
        :session_secret => node['skveez_promo']['session_secret']
      )
    end
  end

  action ::File.exists?("/var/www/current") ? :deploy : :force_deploy
end

template "#{node['nginx']['dir']}/sites-available/konkurs1.skveez.com" do
  source "konkurs1.skveez.com.erb"
  variables :max_upload_size => node['skveez_promo']['max_upload_size']
  notifies :reload, "service[nginx]"
end

nginx_site "konkurs1.skveez.com"
