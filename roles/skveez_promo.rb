name "skveez_promo"

run_list(
  "role[skveez_node]",
  "recipe[skveez_promo]",
  "recipe[postfix::client]",
  "recipe[skveez_host::guest]",
  "recipe[tarsnap::mysql]"
)

override_attributes(
  "postfix" => {
    "relayhost_role" => "skveez_mail",
    "mail_type" => "client",
    "mydomain" => "skveez.com",
    "myorigin" => "skveez.com"
  },
  "tarsnap" => {
    "backup_dirs" => %w{ /etc /usr/local/etc /var/www /var/lib/mysql }
  }
)
