name "skveez_database"

run_list(
  "role[skveez_node]",
  "recipe[skveez_database]",
  "recipe[skveez_host::guest]"
)
