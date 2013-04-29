name             'tarsnap'
version          '0.1.0'

%w{ build-essential }.each do |cb|
  depends cb
end
