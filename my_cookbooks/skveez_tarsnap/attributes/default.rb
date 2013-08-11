default['skveez_tarsnap']['source_url']      = "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.33.tgz"
default['skveez_tarsnap']['source_checksum'] = "0c0d825a8c9695fc8d44c5d8c3cd17299c248377c9c7b91fdb49d73e54ae0b7d"
default['skveez_tarsnap']['cache_dir']       = "/var/lib/tarsnap/cache"
default['skveez_tarsnap']['temp_dir']        = "/var/lib/tarsnap/temp"   # db backups are stored here before being tarsnapped

default['skveez_tarsnap']['backup_dirs'] = %w{ /etc /usr/local/etc }

default['skveez_tarsnap']['account_login']    = ""
default['skveez_tarsnap']['account_password'] = ""
default['skveez_tarsnap']['mailto_reports']   = "root"

default['skveez_tarsnap']['mysql_login']    = "root"
default['skveez_tarsnap']['mysql_password'] = node['mysql']['server_root_password']

default['skveez_tarsnap']['backup_files']['keep_copies'] = 7
default['skveez_tarsnap']['backup_files']['schedule']    = "0 0 * * *"

default['skveez_tarsnap']['backup_mysql_incremental']['keep_copies'] = 7
default['skveez_tarsnap']['backup_mysql_incremental']['schedule']    = "0 3 * * 1,2,3,4,5,6"

default['skveez_tarsnap']['backup_mysql_full']['keep_copies'] = 7
default['skveez_tarsnap']['backup_mysql_full']['schedule']    = "0 3 * * 7"

default['skveez_tarsnap']['backup_mongodb']['keep_copies'] = 7
default['skveez_tarsnap']['backup_mongodb']['schedule']    = "0 3 * * 7"
