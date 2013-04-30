include_attribute "php"

default["skveez_application"]["max_upload_size"] = 100
default["skveez_application"]["memory_limit"] = 32768

override["php"]["packages"] = default["php"]["packages"] + %w{
  php-apc
  php5-curl
  php5-gd
  php5-intl
  php5-mongo
  php5-mysql
}

override["nginx"]["default_site_enabled"] = false

override["php-fpm"]["pools"] = []
override["php-fpm"]["pool"] = {}
