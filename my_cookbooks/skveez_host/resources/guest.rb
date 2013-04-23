actions :create, :delete
default_action :create

attribute :name,           :kind_of => String, :name_attribute => true
attribute :memory,         :kind_of => Integer
attribute :disk_size,      :kind_of => String
attribute :template_image, :kind_of => String
attribute :ip,             :kind_of => String
attribute :mac,            :kind_of => String
attribute :vnc_port,       :kind_of => Integer
attribute :ssh_port,       :kind_of => Integer
