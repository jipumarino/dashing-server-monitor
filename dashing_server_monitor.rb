require 'json'
require 'yaml'

path = File.expand_path(File.dirname(__FILE__))
config = YAML.load_file("#{path}/config.yml")

# Hostname
hostname = `hostname`

loop do
  # HDD
  df_string = `df`
  percents = df_string.split("\n")[1..-1].map do |line|
    line.split(" ")[4].to_i
  end
  hdd = percents.max

  # Memory
  free_string = `free`
  values = free_string.split("\n")[1].split(" ")
  mem = (values[2].to_f/values[1].to_f*100.0).round

  # Load
  uptime_string = `uptime`
  load = uptime_string.match(/load average: ([^,]+),/)[1]

  data = {
    load: load,
    mem: mem,
    hdd: hdd,
    auth_token: config["auth_token"]
  }

  `curl -s -d '#{data.to_json}' http://#{config["dashboard_hostname"]}/widgets/server-#{hostname}`
  puts "curl -s -d '#{data.to_json}' http://#{config["dashboard_hostname"]}/widgets/server-#{hostname}"

  sleep(15)
end
