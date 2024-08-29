#!/bin/bash

# Function to check if CloudWatch Agent is running
check_cw_agent() {
  if ! pgrep -f amazon-cloudwatch-agent; then
    return 1
  fi
  return 0
}

# Initial run to fetch CloudWatch Agent configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:${SSM_PARAMETER_FILE}
