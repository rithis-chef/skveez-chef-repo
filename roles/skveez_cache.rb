name "skveez_cache"

run_list(
  "role[skveez_node]",
  "recipe[skveez_cache]",
  "recipe[skveez_host::guest]"
)
