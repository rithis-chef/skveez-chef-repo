action :create do
  name_normalized = new_resource.name.downcase.tr(" ", "_")

  run_cmd = %Q{LANG=C #{new_resource.before_run} && /usr/local/bin/tarsnap -c -v -f #{name_normalized}_`date '+\\%Y-\\%m-\\%d_\\%H-\\%M'` #{new_resource.pathnames.join(" ")}}
  run_cmd << %Q{ 2>&1 | mail -s "tarsnap report for `date '+\\%Y-\\%m-\\%d_\\%H-\\%M'` from `hostname`" #{node["tarsnap"]["mailto_reports"]}}

  cron "tarsnap #{new_resource.name}" do
    minute  new_resource.minute 
    hour    new_resource.hour
    day     new_resource.day
    month   new_resource.month
    weekday new_resource.weekday
    
    action :create
    mailto node["tarsnap"]["mailto_reports"]

    command run_cmd
  end

  cleanup_cmd = "/usr/local/bin/tarsnap_janitor #{name_normalized} #{new_resource.keep_copies}"

  cron "tarsnap janitor #{new_resource.name}" do
    minute  "0"
    hour    "0"
    day     "*"
    month   "*"
    weekday "*"

    action :create
    mailto node["tarsnap"]["mailto_reports"]

    command cleanup_cmd
  end

  new_resource.updated_by_last_action(true) 
end

action :delete do
  cron "tarsnap #{new_resource.name}" do
    action :delete
  end

  cron "tarsnap janitor #{new_resource.name}" do
    action :delete
  end
end
