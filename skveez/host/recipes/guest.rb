execute "passwd -d ubuntu" do
  not_if do
    ::File.read("/etc/shadow").include? "\nubuntu::"
  end
end

guests = data_bag "skveez_guests"

guests.map! do |id|
  data_bag_item "skveez_guests", id
end

guests.select! do |guest|
  guest["name"] == node.name
end

guest = guests.first

host_node = search(:node, "name:#{guest["host"]}").first
node.set["skveez_host_connection"] = "#{host_node["ipaddress"]}:#{guest["ssh_port"]}"
