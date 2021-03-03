#!/bin/bash -e

JENKINS_ENV=$1

if [ $# -ne 1 ]; then
    echo "Missing required parameter. Jenkins env."
    echo "Usage: ./find-ecs-jenkins-master.sh ops"
    exit 1
fi

ECS_CLUSTER_NAME="wb-cmd-$JENKINS_ENV-ecs-jenkins-cluster"
ECS_SERVICE_NAME="wb-cmd-$JENKINS_ENV-ecs-jenkins-master"

steady_state="(service wb-cmd-$JENKINS_ENV-ecs-jenkins-master) has reached a steady state."

service_state=$(aws ecs describe-services --cluster $ECS_CLUSTER_NAME --services $ECS_SERVICE_NAME --query 'services[*].events[0].message' --output text)

echo "$service_state"

if [ "$steady_state" == "$service_state" ]; then
    echo "Running ecs force deployment!"
    aws ecs update-service --force-new-deployment --cluster $ECS_CLUSTER_NAME --service $ECS_SERVICE_NAME --query 'service.deployments[0]'
fi

exit 0;