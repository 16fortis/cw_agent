#!/bin/bash
# Install custom prerequisites
sudo yum install collectd -y
sudo systemctl start collectd.service

# packages:
#   yum:
#     collectd: []

# commands:
#   01_start_collectd:
#     command: "sudo systemctl start collectd.service"
#     ignoreErrors: false
