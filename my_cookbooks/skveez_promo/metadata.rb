name    "skveez_promo"
version "0.1.0"

%w{ application database mysql nginx php php-fpm }.each do |cb|
  depends cb
end
