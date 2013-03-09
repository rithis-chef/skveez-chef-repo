name "skveez_search"

run_list(
  "role[skveez_node]",
  "recipe[java]",
  "recipe[elasticsearch]",
  "recipe[skveez_host::guest]"
)
