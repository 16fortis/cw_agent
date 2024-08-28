#!/bin/bash

# Get environment information
REGION=$(aws configure get region)
ENVIRONMENT_NAME=$(jq -r '.environment_name' .elasticbeanstalk/config.yml)
APPLICATION_NAME=$(jq -r '.application_name' .elasticbeanstalk/config.yml)

# Get S3 bucket associated with Elastic Beanstalk
S3_BUCKET=$(aws elasticbeanstalk describe-application-versions --application-name "$APPLICATION_NAME" --query "ApplicationVersions[?VersionLabel=='$APPLICATION_NAME'].SourceBundle.S3Bucket" --output text)

# Get latest uploaded application version
LATEST_VERSION=$(aws elasticbeanstalk describe-application-versions --application-name "$APPLICATION_NAME" --query "ApplicationVersions | [-1:].SourceBundle.S3Key" --output text)

# Construct S3 URL
S3_PATH="s3://$S3_BUCKET/$LATEST_VERSION"

echo "The latest application version S3 path is: $S3_PATH"

# Optionally, you can save this path to a file or environment variable
echo $S3_PATH > latest_s3_path.txt
