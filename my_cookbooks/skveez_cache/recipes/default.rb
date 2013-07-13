directory "/var/lib/varnish/#{node["fqdn"]}" do
  recursive true
end

node.set["application_nodes"] = search(:node, "role:skveez_application").map do |application_node|
  application_node["ipaddress"]
end

include_recipe "varnish"
