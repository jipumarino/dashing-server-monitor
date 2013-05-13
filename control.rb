require 'daemons'
Daemons.run File.join(File.dirname(__FILE__), 'dashing_server_monitor.rb'), log_output: true, backtrace: true, monitor: true
