action :create do
  vg  = node["skveez_host"]["guest"]["lvm_vg"]
  dev = "/dev/#{vg}/#{new_resource.name}"

  lvm_logical_volume new_resource.name do
    group vg
    size new_resource.disk_size
  end

  fdisk_commands = ["d", "n", "p", "1", "", "", "w"].join "\n"

  execute "roll_out_filesystem_#{new_resource.name}" do
    command <<-EOS
      qemu-img convert #{new_resource.template_image} #{dev}
      echo "#{fdisk_commands}" | fdisk #{dev}
      kpartx -a #{dev}
      e2fsck -pf /dev/mapper/#{vg}-#{new_resource.name}p1
      resize2fs /dev/mapper/#{vg}-#{new_resource.name}p1
      sleep 3
      kpartx -d #{dev}
    EOS
    not_if do
      ::File.exists? "/etc/libvirt/qemu/#{new_resource.name}.xml"
    end
  end

  template "/etc/libvirt/hooks/qemu-#{new_resource.name}" do
    mode 0700
    source "qemu_domain_hook.erb"
    variables :ip => new_resource.ip, :port => new_resource.ssh_port
  end

  libvirt_domain new_resource.name do
    memory new_resource.memory
    disks [{"dev" => dev}]
    mac new_resource.mac
    vnc_port new_resource.vnc_port
    action [:define, :autostart, :start]
  end
end

action :delete do
  vg  = node["skveez_host"]["guest"]["lvm_vg"]
  dev = "/dev/#{vg}/#{new_resource.name}"

  libvirt_domain new_resource.name do
    action [:destroy, :undefine]
  end

  execute "lvremove -f #{dev}" do
    only_if do
      ::File.exists? dev
    end
  end

  file "/etc/libvirt/hooks/qemu-#{new_resource.name}" do
    action :delete
  end
end
