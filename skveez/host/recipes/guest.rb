execute "passwd -d ubuntu" do
  not_if do
    ::File.read("/etc/shadow").include? "\nubuntu::"
  end
end
