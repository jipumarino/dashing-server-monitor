require 'daemons'
Daemons.run File.join(File.dirname(__FILE__), 'dashing_server_monitor.rb')
