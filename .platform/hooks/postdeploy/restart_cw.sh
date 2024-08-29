#!/bin/bash

# Check and restart CloudWatch Agent if necessary
check_cw_agent
if [ $? -ne 0 ]; then
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:${SSM_PARAMETER_FILE}
fi
