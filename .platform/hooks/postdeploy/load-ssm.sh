#!/bin/bash

# Debugging Information
echo "=== Debugging Information ==="
echo "Current working directory:"
pwd  # Print the current working directory
echo "Files in the current directory:"
ls -l  # List all files in the current directory
echo "============================="

# Fetch the application name and environment from config
APPLICATION_NAME=$(jq -r '.application_name' .elasticbeanstalk/config.yml)
ENVIRONMENT_NAME=$(jq -r '.environment_name' .elasticbeanstalk/config.yml)

# Get the S3 bucket and the latest key of the application version
S3_BUCKET=$(aws elasticbeanstalk describe-application-versions --application-name "$APPLICATION_NAME" --query "ApplicationVersions | [-1:].SourceBundle.S3Bucket" --output text)
LATEST_VERSION_KEY=$(aws elasticbeanstalk describe-application-versions --application-name "$APPLICATION_NAME" --query "ApplicationVersions | [-1:].SourceBundle.S3Key" --output text)

# Extract the folder name from the latest version key (the version archive folder in S3)
ARCHIVE_FOLDER=$(basename "$LATEST_VERSION_KEY" .zip)

# Construct the path to the cw-parameter.config file in the extracted application source
CWAGENT_CONFIG_FILE="$ARCHIVE_FOLDER/.ebextensions/cw-parameter.config"

# Check if the file exists and upload it to SSM
if [ -f "$CWAGENT_CONFIG_FILE" ]; then
  echo "Uploading CloudWatch Agent configuration to SSM Parameter Store..."
  aws ssm put-parameter \
    --name "cwagent" \
    --type "String" \
    --value "$(cat $CWAGENT_CONFIG_FILE)" \
    --overwrite

  echo "Upload completed successfully."
else
  echo "CloudWatch Agent configuration file not found: $CWAGENT_CONFIG_FILE"
  exit 1
fi
