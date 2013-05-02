actions :create, :delete
default_action :create

attribute :name,        :kind_of => String, :name_attribute => true
attribute :pathnames,   :kind_of => Array
attribute :minute,      :kind_of => String
attribute :hour,        :kind_of => String
attribute :day,         :kind_of => String
attribute :month,       :kind_of => String
attribute :weekday,     :kind_of => String
attribute :before_run,  :kind_of => String,  :default => ":"      # true
attribute :keep_copies, :kind_of => Integer, :default => -1       # unlimited
