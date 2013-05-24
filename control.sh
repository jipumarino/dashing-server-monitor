#!/bin/sh
while [ 1 ]; do
    bundle exec ruby ./dashing_server_monitor.rb
    sleep 15
done
 