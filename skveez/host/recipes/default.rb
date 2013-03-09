include_recipe "libvirt"
include_recipe "lvm"
include_recipe "nginx"

package "kpartx"

# template
template_iso   = "#{node["skveez_host"]["template"]["dir"]}/#{node["skveez_host"]["template"]["name"]}.iso"
template_image = "#{node["skveez_host"]["template"]["dir"]}/#{node["skveez_host"]["template"]["name"]}.qcow2"

remote_file template_iso do
  backup false
  checksum node["skveez_host"]["template"]["iso_checksum"]
  source node["skveez_host"]["template"]["iso_url"]
end

execute "qemu-img create #{template_image} #{node["skveez_host"]["template"]["image_size"]}" do
  creates template_image
end

libvirt_domain node["skveez_host"]["template"]["name"] do
  disks [{"file" => template_image}]
  iso template_iso
  action :define
end

# guests
guests = []

data_bag("skveez_guests").each do |name|
  guests.push data_bag_item("skveez_guests", name)
end

skveez_host_network "local" do
  guests guests
end

guests.each do |guest|
  skveez_host_guest guest["id"] do
    memory guest["memory"]
    disk_size guest["disk_size"]
    template_image template_image
    ip guest["ip"]
    mac guest["mac"]
    vnc_port guest["vnc_port"]
    ssh_port guest["ssh_port"]
    action guest["action"]
  end
end

# application
application_nodes = search(:node, "role:skveez_application")

if application_nodes.length > 0
  template "#{node["nginx"]["dir"]}/sites-available/skveez.com" do
    source "skveez.com.erb"
    variables :application_nodes => application_nodes
    notifies :reload, "service[nginx]"
  end

  nginx_site "skveez.com"
end
