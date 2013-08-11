if node['platform'] == "centos"
  %w{ cronie sendmail }.each do |pkg|
    package pkg
  end

  %w{ sendmail crond }.each do |svc|
    service svc do
      action [ :enable, :start ]
    end
  end

  yum_repository "10gen" do
    description "10gen RPM Repository"
    url "http://downloads-distro.mongodb.org/repo/redhat/os/#{node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'}"
    action :add
  end
end

skveez_tarsnap_archive "System configs" do
  pathnames %w{ /etc /usr/local/etc }
  day "*"
  hour "0"
  minute "0"
end

%w{ mysql::server tarsnap::mysql database::mysql }.each do |recipe|
  include_recipe recipe
end

cookbook_file "#{Chef::Config[:file_cache_path]}/sampledatabase.sql"

mysql_database "classicmodels" do
  connection({
    :host     => "localhost",
    :username => "root",
    :password => node['mysql']['server_root_password']
  })
  sql { ::File.open("#{Chef::Config[:file_cache_path]}/sampledatabase.sql").read }
  action :create
end

include_recipe "mongodb::10gen_repo"

mongo_pkgs = case node['platform']
             when "centos"
               %w{ mongo-10gen-server mongo-10gen }
             when "ubuntu", "debian"
               %w{ mongodb-10gen }
             end

mongo_pkgs.each do |pkg|
  package pkg
end

include_recipe "tarsnap::mongodb"
