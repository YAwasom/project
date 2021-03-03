#!/bin/bash -e
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

${pre_install}

# Install updates
yum update -y --disableplugin=priorities

yum install -y yum-plugin-kernel-livepatch

yum kernel-livepatch enable -y

yum update -y kpatch-runtime

systemctl enable kpatch.service

amazon-linux-extras enable livepatch

yum update -y --security --disableplugin=priorities

# Install cloudwatch agent
%{ if enable_cloudwatch_agent ~}
yum install amazon-cloudwatch-agent -y
amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:${ssm_key_cloudwatch_agent_config}
%{ endif ~}

# Install docker
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user

yum install -y curl wget jq git

# Set hostname
instance_id=$(ec2-metadata -i | cut -d " " -f 2)
ec2_hostname="ops-github-runner"
hostnamectl set-hostname $ec2_hostname-$instance_id

USER_NAME=ec2-user
${install_config_runner}

${post_install}

./svc.sh start