#!/bin/bash -e
# Protect instance if there are >= 2 docker containers running
# needs to take into account ecs container which manages the tasks
# This script is on a cron set in the user data for ec2 instances
# If the instance is in an unhealthy state unset protection

AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -c -r .region)

export AWS_DEFAULT_REGION="$AWS_REGION";

ECS_CLUSTER_NAME="$(curl -s --fail http://localhost:51678/v1/metadata | jq -er '.Cluster')"
ECS_SERVICE_NAME="${ECS_CLUSTER_NAME%-*}-master"

CONTAINER_INSTANCE_ARN="$(curl -s --fail http://localhost:51678/v1/metadata | jq -er '.ContainerInstanceArn')"

INSTANCE_ID=$(aws ecs describe-container-instances --container-instances $CONTAINER_INSTANCE_ARN --cluster $ECS_CLUSTER_NAME | jq --raw-output '[.containerInstances] | .[] | .[] | .ec2InstanceId')

AUTO_SCALE=$(aws autoscaling describe-auto-scaling-instances --instance-ids $INSTANCE_ID | jq '[.AutoScalingInstances] | .[] | .[]')

PROTECT_FROM_SCALE=$(echo $AUTO_SCALE | jq --raw-output .ProtectedFromScaleIn)
HEALTH_STATUS=$(echo $AUTO_SCALE | jq --raw-output .HealthStatus)

NUM_REQUIRED_FOR_PROTECTION="2"
NUM_RUNNING_CONTAINERS=$(docker info --format '{{json .}}' | jq '[.ContainersRunning] | .[]')

echo "Container instance id: $INSTANCE_ID"
echo "Number of running containers: $NUM_RUNNING_CONTAINERS"
echo "Protected from scale in: $PROTECT_FROM_SCALE"
echo "Health status: $HEALTH_STATUS"

if [ "$NUM_RUNNING_CONTAINERS" -ge "$NUM_REQUIRED_FOR_PROTECTION" ] && [ "$PROTECT_FROM_SCALE" == "true" ] && [ "$HEALTH_STATUS" == "HEALTHY" ]; then
  echo "Instance is healthy and already protected. Do nothing."
  exit 0;
fi

if [ "$NUM_RUNNING_CONTAINERS" -lt "$NUM_REQUIRED_FOR_PROTECTION" ] || [ "$HEALTH_STATUS" == "UNHEALTHY" ] ; then
  aws autoscaling set-instance-protection --no-protected-from-scale-in --instance-ids "$INSTANCE_ID" --auto-scaling-group-name "$ECS_SERVICE_NAME-asg"
  echo "Remove instance protection on $INSTANCE_ID"
else
  aws autoscaling set-instance-protection --protected-from-scale-in --instance-ids "$INSTANCE_ID" --auto-scaling-group-name "$ECS_SERVICE_NAME-asg"
  echo "Set instance protection on $INSTANCE_ID"
fi

echo "DONE"
exit 0;