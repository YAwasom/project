#!/bin/bash -e
# ECS plugin doesn't yet support https://github.com/jenkinsci/amazon-ecs-plugin/pull/81
# Once it does, we can place all build tasks outside of the master service 
# and we won't have to kill the master when the ebs volume fills from slave tasks
# We also might not need the above, I think this should suffice for now.
# Terminate the instance once /var/lib/docker is at 85% and there are <= 2 containers running
# If we are on the master node and <= 1 container on a slave instance

AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -c -r .region)

export AWS_DEFAULT_REGION="$AWS_REGION";

ECS_CLUSTER_NAME="$(curl -s --fail http://localhost:51678/v1/metadata | jq -er '.Cluster')"
ECS_SERVICE_NAME="${ECS_CLUSTER_NAME%-*}-master"

CONTAINER_INSTANCE_ARN="$(curl -s --fail http://localhost:51678/v1/metadata | jq -er '.ContainerInstanceArn')"

INSTANCE_ID=$(aws ecs describe-container-instances --container-instances $CONTAINER_INSTANCE_ARN --cluster $ECS_CLUSTER_NAME | jq --raw-output '[.containerInstances] | .[] | .[] | .ec2InstanceId')

JENKINS_MASTER_TASK=$(curl http://localhost:51678/v1/tasks | jq -r --arg ECS_SERVICE_NAME "$ECS_SERVICE_NAME" '[.Tasks] | .[] | .[] | .Containers | map(select(.Name | contains($ECS_SERVICE_NAME))) | .[]  | .Name')

IS_JENKINS_MASTER_RUNNING="false"
if [ "$JENKINS_MASTER_TASK" == "$ECS_SERVICE_NAME" ]; then
  echo "The master is running on this instance"
  IS_JENKINS_MASTER_RUNNING="true"
fi

NUM_REQUIRED_FOR_DELETE="1"
NUM_REQUIRED_FOR_DELETE_WITH_MASTER="2"
NUM_RUNNING_CONTAINERS=$(docker info --format '{{json .}}' | jq '[.ContainersRunning] | .[]')

PERCENT_SPACE_LEFT=$(df -h /var/lib/docker | awk '$3 ~ /[0-9]+/ { print $5 }')
PERCENT_SPACE_LEFT=${PERCENT_SPACE_LEFT::-1}
MAX_MEMORY_PERCENT="85"

echo "Container instance id: $INSTANCE_ID"
echo "Number of running containers: $NUM_RUNNING_CONTAINERS"
echo "Percent space left on /var/lib/docker: $PERCENT_SPACE_LEFT"

if [ "$PERCENT_SPACE_LEFT" -ge "$MAX_MEMORY_PERCENT" ] && [ "$IS_JENKINS_MASTER_RUNNING" == "true" ] && [ "$NUM_RUNNING_CONTAINERS" -le "$NUM_REQUIRED_FOR_DELETE_WITH_MASTER" ]; then
  echo "Remove instance protection on $INSTANCE_ID"
  aws autoscaling set-instance-protection --no-protected-from-scale-in --instance-ids "$INSTANCE_ID" --auto-scaling-group-name "$ECS_SERVICE_NAME-asg"
  echo "Terminating $INSTANCE_ID"
  aws autoscaling terminate-instance-in-auto-scaling-group --instance-id "$INSTANCE_ID" --no-should-decrement-desired-capacity
  exit 0;
fi

if [ "$PERCENT_SPACE_LEFT" -ge "$MAX_MEMORY_PERCENT" ] && [ "$IS_JENKINS_MASTER_RUNNING" == "false" ] && [ "$NUM_RUNNING_CONTAINERS" -le "$NUM_REQUIRED_FOR_DELETE" ]; then
  echo "Remove instance protection on $INSTANCE_ID"
  aws autoscaling set-instance-protection --no-protected-from-scale-in --instance-ids "$INSTANCE_ID" --auto-scaling-group-name "$ECS_SERVICE_NAME-asg"
  echo "Terminating $INSTANCE_ID"
  aws autoscaling terminate-instance-in-auto-scaling-group --instance-id "$INSTANCE_ID" --no-should-decrement-desired-capacity
  exit 0;
fi

echo "DONE"
exit 0;