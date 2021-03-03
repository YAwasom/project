#!/bin/bash
# ./multi-account-deploy.sh "aws s3 ls"
# ./multi-account-deploy.sh "simple-cfn deploy cloud-custodian-ops-role templates/custodian.role.yaml --file=parameters/custodian.role.yaml"

cmd=$1
region=${2:-us-west-2}

[ "$#" -eq 1 ] || exit

IFS=$'\n'
for aws_profile in $(awsp)
do
    export AWS_PROFILE="$aws_profile"
    export AWS_REGION="$region"
    echo "Deploying to $aws_profile"
    echo "Running: $cmd"
    eval "$cmd"
done
