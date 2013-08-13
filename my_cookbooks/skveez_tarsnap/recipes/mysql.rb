case node['platform']
when "centos", "redhat"
  yum_repository "percona" do
    url "http://repo.percona.com/centos/$releasever/os/$basearch/"
  end
when "debian", "ubuntu"
  apt_repository "percona" do
    uri          "http://repo.percona.com/apt"
    distribution node['lsb']['codename']
    components   [ "main" ]
    keyserver    "keys.gnupg.net"
    key          "CD2EFD2A"
  end
else 
  raise "Unsupported platform"
end

package "xtrabackup"

%w{ full incr }.each do |subdir|
  directory "#{node['skveez_tarsnap']['temp_dir']}/mysql/#{subdir}" do
    recursive true
  end
end

%w{ mysql_backup_full mysql_backup_incremental }.each do |script|
  cookbook_file "/usr/local/bin/#{script}" do
    mode "0755"
  end
end

template "/usr/local/etc/mysql_backup.conf"

skveez_tarsnap_archive "MySQL full backup" do
  pathnames  [ "#{node['skveez_tarsnap']['temp_dir']}/mysql/full" ]
  before_run "/usr/local/bin/mysql_backup_full"

  minute  node['skveez_tarsnap']['backup_mysql_full']['schedule'].split[0]
  hour    node['skveez_tarsnap']['backup_mysql_full']['schedule'].split[1]
  day     node['skveez_tarsnap']['backup_mysql_full']['schedule'].split[2]
  month   node['skveez_tarsnap']['backup_mysql_full']['schedule'].split[3]
  weekday node['skveez_tarsnap']['backup_mysql_full']['schedule'].split[4]

  keep_copies node['skveez_tarsnap']['backup_mysql_full']['keep_copies']
end

skveez_tarsnap_archive "MySQL incremental backup" do
  pathnames  [ "#{node['skveez_tarsnap']['temp_dir']}/mysql/incr/`date '+\%Y-\%m-\%d'`_*" ]
  before_run "/usr/local/bin/mysql_backup_incremental"

  minute  node['skveez_tarsnap']['backup_mysql_incremental']['schedule'].split[0]
  hour    node['skveez_tarsnap']['backup_mysql_incremental']['schedule'].split[1]
  day     node['skveez_tarsnap']['backup_mysql_incremental']['schedule'].split[2]
  month   node['skveez_tarsnap']['backup_mysql_incremental']['schedule'].split[3]
  weekday node['skveez_tarsnap']['backup_mysql_incremental']['schedule'].split[4]

  keep_copies node['skveez_tarsnap']['backup_mysql_incremental']['keep_copies']
end
