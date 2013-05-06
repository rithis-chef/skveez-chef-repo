default['tarsnap']['source_url']      = "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.33.tgz"
default['tarsnap']['source_checksum'] = "0c0d825a8c9695fc8d44c5d8c3cd17299c248377c9c7b91fdb49d73e54ae0b7d"
default['tarsnap']['cache_dir']       = "/var/lib/tarsnap/cache"
default['tarsnap']['temp_dir']        = "/var/lib/tarsnap/temp"   # db backups are stored here before being tarsnapped

default['tarsnap']['backup_dirs'] = %w{ /etc /usr/local/etc }

default['tarsnap']['account_login']    = ""
default['tarsnap']['account_password'] = ""
default['tarsnap']['mailto_reports']   = "root"

default['tarsnap']['mysql_login']    = "root"
default['tarsnap']['mysql_password'] = node['mysql']['server_root_password']

default['tarsnap']['backup_files']['keep_copies'] = 7
default['tarsnap']['backup_files']['schedule']    = "0 0 * * *"

default['tarsnap']['backup_mysql_incremental']['keep_copies'] = 7
default['tarsnap']['backup_mysql_incremental']['schedule']    = "0 3 * * 1,2,3,4,5,6"

default['tarsnap']['backup_mysql_full']['keep_copies'] = 7
default['tarsnap']['backup_mysql_full']['schedule']    = "0 3 * * 7"

default['tarsnap']['backup_mongodb']['keep_copies'] = 7
default['tarsnap']['backup_mongodb']['schedule']    = "0 3 * * 7"
