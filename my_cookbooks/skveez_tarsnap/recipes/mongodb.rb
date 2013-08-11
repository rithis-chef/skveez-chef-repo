directory "#{node['skveez_tarsnap']['temp_dir']}/mongodb"

template "/usr/local/bin/mongo_backup" do
  mode "0700"
end

skveez_tarsnap_archive "Mongodb backup" do
  pathnames  [ "#{node['skveez_tarsnap']['temp_dir']}/mongodb" ]
  before_run "/usr/local/bin/mongo_backup"

  minute  node['skveez_tarsnap']['backup_mongodb']['schedule'].split[0]
  hour    node['skveez_tarsnap']['backup_mongodb']['schedule'].split[1]
  day     node['skveez_tarsnap']['backup_mongodb']['schedule'].split[2]
  month   node['skveez_tarsnap']['backup_mongodb']['schedule'].split[3]
  weekday node['skveez_tarsnap']['backup_mongodb']['schedule'].split[4]

  keep_copies node['skveez_tarsnap']['backup_mongodb']['keep_copies']
end
