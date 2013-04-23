action :redefine do
  dns_hosts = []
  dhcp_hosts = []

  new_resource.guests.each do |guest|
    if guest["action"] == "create"
      dns_hosts.push(
        "ip" => guest["ip"],
        "hostname" => guest["id"]
      )

      dhcp_hosts.push(
        "ip" => guest["ip"],
        "mac" => guest["mac"],
        "name" => "#{guest["id"]}.#{new_resource.domain}"
      )
    end
  end

  libvirt_network "default" do
    domain new_resource.domain
    dns_hosts dns_hosts
    dhcp_hosts dhcp_hosts
    action :redefine
  end

  template "/etc/libvirt/hooks/qemu" do
    mode 0700
    source "qemu_hook.erb"
    notifies :restart, "service[libvirt-bin]", :immediately
  end
end
