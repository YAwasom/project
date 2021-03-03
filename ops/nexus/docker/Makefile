ROOT:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
IMAGE_NAME:=cmd/nexus

ECR_TAG:="latest"
AWS_REGION:="us-west-2"
AWS_ACCOUNT_ID:="348180535083"
BUILD_DATE:=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
VCS_REF:=$(shell git log --pretty=format:'%h' -n 1)
SCHEMA_VERSION=0.0.2
REGISTRY_URI=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}
REGISTRY_URI_WITH_TAG=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:${ECR_TAG}

# Login to AWS ECR registry (must have docker running)
login:
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REGISTRY_URI}

build:
	docker build --no-cache -t ${IMAGE_NAME}:${ECR_TAG} \
	--build-arg BUILD_DATE=${BUILD_DATE} \
	--build-arg VCS_REF=${VCS_REF} \
	--build-arg SCHEMA_VERSION=${SCHEMA_VERSION} .

# Tag docker image
tag:
	docker tag ${IMAGE_NAME}:${ECR_TAG} ${REGISTRY_URI_WITH_TAG}

# Push to ECR registry
push:
	docker push ${REGISTRY_URI_WITH_TAG}

# Pull version from ECR registry
pull:
	docker pull ${REGISTRY_URI_WITH_TAG}

# Build docker image and push to AWS ECR registry
all: login build tag push