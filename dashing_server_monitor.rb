require 'json'
require 'yaml'
require 'socket'
require 'sigar'

path = File.expand_path(File.dirname(__FILE__))
config = YAML.load_file("#{path}/config.yml")

loop do
  sigar = Sigar.new

  data = {
    load: sigar.loadavg.first.round(2),
    mem: (sigar.mem.actual_used.to_f/sigar.mem.total.to_f*100).round(1),
    hdd: sigar.file_system_list.map{|fs| sigar.file_system_usage(fs.dir_name).use_percent*100}.max.round(1),
    auth_token: config["auth_token"]
  }

  hostname = sigar.net_info.host_name
  `curl -s -d '#{data.to_json}' http://#{config["dashboard_hostname"]}/widgets/server-#{hostname}`

  sleep(15)
end
