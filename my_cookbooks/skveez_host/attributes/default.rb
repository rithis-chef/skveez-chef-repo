default["skveez_host"]["template"]["dir"]          = "/var/lib/libvirt/images"
default["skveez_host"]["template"]["name"]         = "ubuntu-12.10-server-i386"
default["skveez_host"]["template"]["iso_url"]      = "http://releases.ubuntu.com/12.10/ubuntu-12.10-server-i386.iso"
default["skveez_host"]["template"]["iso_checksum"] = "2e37611224dad7e40336f6dcfa24c3c693f32f751ec38c931291893d0c1b1d0d"
default["skveez_host"]["template"]["image_size"]   = "2G"

default["skveez_host"]["guest"]["lvm_vg"] = "virvg"

override["nginx"]["default_site_enabled"] = false
