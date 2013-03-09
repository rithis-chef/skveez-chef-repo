name "skveez_sessions"

run_list(
  "role[skveez_node]",
  "recipe[mongodb::10gen_repo]",
  "recipe[skveez_host::guest]"
)
