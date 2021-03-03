#!/bin/bash
echo ECS_CLUSTER=efd-${app}-${efdenv} >> /etc/ecs/ecs.config
echo ECS_ENABLE_TASK_IAM_ROLE=true >> /etc/ecs/ecs.config
echo ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true >> /etc/ecs/ecs.config
echo ECS_IMAGE_PULL_BEHAVIOR=always >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS='["json-file","awslogs"]' >> /etc/ecs/ecs.config

# Install ntp chrony
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
yum -y erase 'ntp*'
yum -y install chrony
service chronyd restart
chkconfig chronyd on

# Install amazon agent
curl https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm -o amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm
yum install -y collectd

# Install awslogs
yum -y install awslogs
service awslogs start

#Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:"${efdenv}/ops.cloudwatch" -s

