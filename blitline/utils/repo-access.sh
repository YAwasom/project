GRANTED_ACCOUNT=$1 
REPO_NAME=$2
echo granting access to account "$1" for ecr repo $2
aws ecr set-repository-policy \
    --repository-name $2 \
    --policy-text file://${PWD}/repository-policy.json