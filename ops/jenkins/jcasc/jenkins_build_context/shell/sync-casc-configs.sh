#!/bin/bash -ex
ENV=$1
CONFIG_PATH=$2

if [[ -z "$ENV" ]] && [[ -z "$CONFIG_PATH" ]]; then
  # Usually sourced from docker container
  echo "Sourcing parameters from environment vars vs params"
  ENV=$AWS_JENKINS_ENVIRONMENT
  CONFIG_PATH=$CASC_JENKINS_CONFIG
fi

echo "Sync casc configs"
aws s3 sync "s3://wb-cmd-${ENV}-s3-jenkins-configuration" $CONFIG_PATH
echo "Sync of casc configs complete"