require 'json'
require 'yaml'
require 'sigar'
require 'net/http'

config = YAML.load_file File.join(File.dirname(__FILE__), 'config.yml')

loop do
  Thread.new do
    sigar = Sigar.new

    data = {
      load: sigar.loadavg.first.round(2),
      mem: (sigar.mem.actual_used.to_f/sigar.mem.total.to_f*100).round(1),
      hdd: sigar.file_system_list.map{|fs| sigar.file_system_usage(fs.dir_name).use_percent*100}.max.round(1),
      auth_token: config["auth_token"]
    }

    req = Net::HTTP::Post.new("/widgets/server-#{sigar.net_info.host_name}", initheader = {'Content-Type' =>'application/json'})
    req.body = data.to_json
    response = Net::HTTP.new(config["dashboard_hostname"]).start {|http| http.request(req) }
  end

  sleep 15
end
