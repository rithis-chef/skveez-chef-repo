actions :create, :delete
default_action :create

attribute :name,        :kind_of => String, :name_attribute => true
attribute :pathnames,   :kind_of => Array
attribute :minute,      :kind_of => String
attribute :hour,        :kind_of => String
attribute :day,         :kind_of => String
attribute :month,       :kind_of => String
attribute :weekday,     :kind_of => String
