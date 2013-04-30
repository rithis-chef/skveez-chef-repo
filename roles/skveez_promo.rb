name "skveez_promo"

run_list(
  "role[skveez_node]",
  "recipe[skveez_promo]",
  "recipe[postfix::client]",
  "recipe[skveez_host::guest]"
)

override_attributes(
  "postfix" => {
    "relayhost_role" => "skveez_mail",
    "mail_type" => "client",
    "mydomain" => "skveez.com",
    "myorigin" => "skveez.com"
  }
)
