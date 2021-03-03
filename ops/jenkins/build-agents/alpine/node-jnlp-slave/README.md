# Description

A Docker image running a node

## Additional Packages

As this image is based on [Alpine Linux](https://hub.docker.com/_/alpine/) the following additional packages have to be installed:

* awscli
* python3
* pip
* git
* curl
* less
* openssh

## Build and deploy

[use aws profile switcher to get the correct creds](../../../../../utilities/aws/profile-switcher/README.md)

```bash
# ECR images are stored in the ops account within us-west-2
awsp ops

cd ops/jenkins/build-agents/alpine/node-jnlp-slave
make all
```

## Jenkins jnlp slave

The Jenkins remoting library (aka _JNLP Slave_ or `slave.jar`) is pulled from the [Jenkins CI Repos](http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/).
