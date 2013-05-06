directory "#{node['tarsnap']['temp_dir']}/mongodb"

template "/usr/local/bin/mongo_backup" do
  mode "0700"
end

tarsnap_archive "Mongodb backup" do
  pathnames  [ "#{node['tarsnap']['temp_dir']}/mongodb" ]
  before_run "/usr/local/bin/mongo_backup"

  minute  node['tarsnap']['backup_mongodb']['schedule'].split[0]
  hour    node['tarsnap']['backup_mongodb']['schedule'].split[1]
  day     node['tarsnap']['backup_mongodb']['schedule'].split[2]
  month   node['tarsnap']['backup_mongodb']['schedule'].split[3]
  weekday node['tarsnap']['backup_mongodb']['schedule'].split[4]

  keep_copies node['tarsnap']['backup_mongodb']['keep_copies']
end
