tarsnap_archive "Filesystem backup" do
  pathnames   node['tarsnap']['backup_dirs']

  minute      node['tarsnap']['backup_files']['schedule'].split[0]
  hour        node['tarsnap']['backup_files']['schedule'].split[1]
  day         node['tarsnap']['backup_files']['schedule'].split[2]
  month       node['tarsnap']['backup_files']['schedule'].split[3]
  weekday     node['tarsnap']['backup_files']['schedule'].split[4]

  keep_copies node['tarsnap']['backup_files']['keep_copies']
end
