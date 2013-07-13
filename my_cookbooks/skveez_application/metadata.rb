name    "skveez_application"
version "0.1.2"

%w{ application nginx php php-fpm }.each do |cb|
  depends cb
end
