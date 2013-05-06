include_recipe "mysql::server"
include_recipe "database::mysql"

node.set_unless['skveez_database']['database'] = "skveez"
node.set_unless['skveez_database']['username'] = "skveez"
node.set_unless['skveez_database']['password'] = secure_password

connection_info = {
  :host => "localhost",
  :port => node['mysql']['port'],
  :username => "root",
  :password => node['mysql']['server_root_password']
}

mysql_database node['skveez_database']['database'] do
  connection connection_info
end

mysql_database_user node['skveez_database']['username'] do
  password node['skveez_database']['password']
  database_name node['skveez_database']['database']
  connection connection_info
  host "%"
  action [:create, :grant]
end
