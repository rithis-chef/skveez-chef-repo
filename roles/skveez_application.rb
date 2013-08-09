name "skveez_application"

run_list(
  "role[skveez_node]",
  "recipe[skveez_application]",
  "recipe[postfix::client]",
  "recipe[skveez_host::guest]",
)

override_attributes(
  "postfix" => {
    "relayhost_role" => "skveez_mail",
    "mail_type" => "client",
    "mydomain" => "skveez.com",
    "myorigin" => "skveez.com"
  },
  "tarsnap" => {
    "backup_dirs" => %w{ /etc /usr/local/etc /var/www/shared/uploads }
  }
)
