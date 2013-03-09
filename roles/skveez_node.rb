name "skveez_node"

run_list(
  "recipe[ubuntu]",
  "recipe[apt]",
  "recipe[vslinko]"
)

override_attributes(
  "ubuntu" => {
    "archive_url" => "http://mirror.hetzner.de/ubuntu/packages",
    "security_url" => "http://mirror.hetzner.de/ubuntu/security",
    "include_source_packages" => false
  }
)
