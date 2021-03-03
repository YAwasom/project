#!/bin/bash -e

JENKINS_ENV=$1

if [ $# -ne 1 ]; then
    echo "Missing required parameter. Jenkins env."
    echo "Usage: ./find-ecs-jenkins-master.sh ops"
    exit 1
fi

ECS_CLUSTER_NAME="wb-cmd-$JENKINS_ENV-ecs-jenkins-cluster"
ECS_SERVICE_NAME="wb-cmd-$JENKINS_ENV-ecs-jenkins-master"

service_state=$(aws ecs describe-services --cluster $ECS_CLUSTER_NAME --services $ECS_SERVICE_NAME --query 'services[*].events[0].message' --output text)

master_container=$(aws ecs list-container-instances --cluster $ECS_CLUSTER_NAME --filter "task:group == service:$ECS_SERVICE_NAME" --query 'containerInstanceArns[*]' --output text)

current_instance_id=$(aws ecs describe-container-instances --container-instances $master_container --cluster $ECS_CLUSTER_NAME --query 'containerInstances[*].ec2InstanceId' --output text)

protect_from_scale_in=$(aws autoscaling describe-auto-scaling-instances --instance-ids $current_instance_id --query 'AutoScalingInstances[*].ProtectedFromScaleIn' --output text)
health_status=$(aws autoscaling describe-auto-scaling-instances --instance-ids $current_instance_id --query 'AutoScalingInstances[*].HealthStatus' --output text)

echo "Jenkins master instance id: $current_instance_id"
echo "Protected from scale in: $protect_from_scale_in"
echo "Health status: $health_status"

exit 0;