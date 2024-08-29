#!/bin/bash

# Fetch CloudWatch Agent configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:${SSM_PARAMETER_FILE}

# Function to check CloudWatch Agent status
check_cw_agent() {
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status | grep -q 'running'
}

# Check and restart CloudWatch Agent if necessary
check_cw_agent
if [ $? -ne 0 ]; then
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:${SSM_PARAMETER_FILE}
fi
