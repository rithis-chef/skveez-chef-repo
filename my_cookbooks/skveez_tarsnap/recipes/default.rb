include_recipe "build-essential"

dependencies = case node['platform']
               when "centos", "redhat"
                 %w{ openssl-devel zlib-devel e2fsprogs-devel mailx }
               when "debian", "ubuntu"
                 %w{ libssl-dev zlib1g-dev e2fslibs-dev mailutils }
               else 
                 raise "Unsupported platform"
               end

dependencies.each do |pkg|
  package pkg
end

tarsnap_archive_name = ::File.basename(node['skveez_tarsnap']['source_url'])
tarsnap_archive_dir  = ::File.basename(node['skveez_tarsnap']['source_url'], ".tgz")

remote_file "#{Chef::Config[:file_cache_path]}/#{tarsnap_archive_name}" do
  source   node['skveez_tarsnap']['source_url']
  checksum node['skveez_tarsnap']['source_checksum']
end

execute "Unpack tarsnap source distribution" do
  command "tar xzf #{tarsnap_archive_name}"
  cwd     Chef::Config[:file_cache_path]

  not_if { ::File.directory? "#{Chef::Config[:file_cache_path]}/#{tarsnap_archive_dir}" }
end

bash "Build tarsnap client" do
  cwd  "#{Chef::Config[:file_cache_path]}/#{tarsnap_archive_dir}"

  code <<-EOH
    set -x
    exec >  #{Chef::Config[:file_cache_path]}/chef-tarsnap-build.log
    exec 2> #{Chef::Config[:file_cache_path]}/chef-tarsnap-build.log
   ./configure && make all install clean
  EOH

  not_if { ::File.exists? "/usr/local/bin/tarsnap" }
end

tarsnap_keygen_cmd = <<-EOS 
  echo "#{node['skveez_tarsnap']['account_password']}" | /usr/local/bin/tarsnap-keygen \
    --keyfile /usr/local/etc/tarsnap.key \
    --user #{node['skveez_tarsnap']['account_login']} \
    --machine #{node['fqdn']}
EOS

if ::File.size?("/usr/local/etc/tarsnap.key").nil?
  unless node['skveez_tarsnap']['machine_key'].nil?
    file "/usr/local/etc/tarsnap.key" do
      content node['skveez_tarsnap']['machine_key']
    end
  else
    execute "Generate keyfile for this machine" do
      command tarsnap_keygen_cmd
    end

    ruby_block "Store tarsnap key in an attribute" do
      block do 
        node.set['skveez_tarsnap']['machine_key'] = ::File.read("/usr/local/etc/tarsnap.key")
      end
    end
  end
end

file "/usr/local/etc/tarsnap.key" do
  owner "root"
  mode  "0600"
end

template "/usr/local/etc/tarsnap.conf" do
  mode "0644"
end

[ node['skveez_tarsnap']['cache_dir'], node['skveez_tarsnap']['temp_dir'] ].each do |dir|
  directory dir do
    recursive true
  end
end

cookbook_file "/usr/local/bin/tarsnap_janitor" do
  mode "0700"
end
