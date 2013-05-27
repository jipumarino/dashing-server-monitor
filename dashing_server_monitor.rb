require 'json'
require 'yaml'
require 'sigar'
require 'curb'

config = YAML.load_file File.join(File.dirname(__FILE__), 'config.yml')

sigar = Sigar.new

data = {
  load: sigar.loadavg.first.round(2),
  mem: (sigar.mem.actual_used.to_f/sigar.mem.total.to_f*100).round(1),
  hdd: sigar.file_system_list.map{|fs| sigar.file_system_usage(fs.dir_name).use_percent*100}.max.round(1),
  auth_token: config["auth_token"]
}

req = Curl.post("http://#{config["dashboard_hostname"]}/widgets/server-#{sigar.net_info.host_name}", data.to_json)

sleep 15
