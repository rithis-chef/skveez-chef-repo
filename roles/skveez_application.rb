name "skveez_application"

run_list(
  "role[skveez_node]",
  "recipe[skveez_application]",
  "recipe[skveez_host::guest]"
)
