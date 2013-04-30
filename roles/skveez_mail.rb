name "skveez_mail"

run_list(
  "role[skveez_node]",
  "recipe[postfix::server]",
  "recipe[skveez_host::guest]"
)

override_attributes(
  "postfix" => {
    "mail_relay_networks" => "192.168.122.0/24",
    "mydomain" => "skveez.com",
    "myorigin" => "skveez.com"
  }
)
