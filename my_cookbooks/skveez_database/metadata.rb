name    "skveez_database"
version "0.1.0"

%w{ database mysql }.each do |cb|
  depends cb
end
