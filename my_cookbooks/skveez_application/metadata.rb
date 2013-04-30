name    "skveez_application"
version "0.0.3"

%w{ application nginx php php-fpm }.each do |cb|
  depends cb
end
