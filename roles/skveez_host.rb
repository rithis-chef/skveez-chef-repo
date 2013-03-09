name "skveez_host"

run_list(
  "role[skveez_node]",
  "recipe[ntp]",
  "recipe[skveez_host]"
)

override_attributes(
  "ntp" => {
    "servers" => %w{ ntp1.hetzner.de ntp2.hetzner.com ntp3.hetzner.net }
  }
)
