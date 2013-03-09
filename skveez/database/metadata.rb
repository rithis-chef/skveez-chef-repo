name    "skveez_database"
version "0.0.0"

%w{ database mysql }.each do |cb|
  depends cb
end
