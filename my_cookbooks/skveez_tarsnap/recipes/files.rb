skveez_tarsnap_archive "Filesystem backup" do
  pathnames node['skveez_tarsnap']['backup_dirs']

  minute  node['skveez_tarsnap']['backup_files']['schedule'].split[0]
  hour    node['skveez_tarsnap']['backup_files']['schedule'].split[1]
  day     node['skveez_tarsnap']['backup_files']['schedule'].split[2]
  month   node['skveez_tarsnap']['backup_files']['schedule'].split[3]
  weekday node['skveez_tarsnap']['backup_files']['schedule'].split[4]

  keep_copies node['skveez_tarsnap']['backup_files']['keep_copies']
end
