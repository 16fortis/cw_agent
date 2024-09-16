#!/bin/bash
# Install custom prerequisites, needed to run cw-agent
sudo yum install collectd -y
sudo systemctl start collectd.service

#Needed to get ARN and make cw alarms
sudo yum update
sudo yum install jq -y