name    "skveez_application"
version "0.1.0"

%w{ application nginx php php-fpm }.each do |cb|
  depends cb
end
