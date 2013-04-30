name "skveez_promo"

run_list(
  "role[skveez_node]",
  "recipe[skveez_promo]",
  "recipe[skveez_host::guest]"
)
