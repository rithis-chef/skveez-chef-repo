name             'tarsnap'
version          '0.1.0'

%w{ apt build-essential database mongodb mysql yum }.each do |cb|
  depends cb
end
