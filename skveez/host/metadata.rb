name    "skveez_host"
version "0.0.1"

%w{ libvirt lvm nginx }.each do |cb|
  depends cb
end
