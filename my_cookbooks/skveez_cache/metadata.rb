name    "skveez_cache"
version "0.1.0"

%w{ varnish }.each do |cb|
  depends cb
end
