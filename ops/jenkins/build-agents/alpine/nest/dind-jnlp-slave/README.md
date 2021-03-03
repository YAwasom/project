# Description

A Docker image running a [jenkins jnlp slave](https://wiki.jenkins.io/display/JENKINS/Distributed+builds) with Docker-in-Docker and [AWS CLI](https://aws.amazon.com/cli/) support.

It extends the official DinD image from [docker-library/docker](https://github.com/docker-library/docker) adding the [jenkins-slave](jenkins-slave) script and the required packages to use it in the AWS Cloud.

Current parent is `stable-dind` (see [docker:stable-dind](https://github.com/docker-library/docker/tree/92d278e671f32a9ee4a3c0668e46a41f4a3b74b0/19.03/dind) for details).

The size of the build image is approximately `350 MB`.

## Additional Packages

As this image is based on [Alpine Linux](https://hub.docker.com/_/alpine/) the following additional packages have to be installed:

* openjdk8
* maven
* awscli
* python3
* pip
* git
* curl
* openssh
* sudo
* ca-certificates
* groff

## Jenkins jnlp slave

The Jenkins remoting library (aka _JNLP Slave_ or `slave.jar`) is pulled from the [Jenkins CI Repos](http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/).

## Docker in Docker

The Docker API access (aka _Docker in Docker_ as the Jenkins slave is running in a Docker Container) for builds creating Docker artefacts is realized via the [`/var/run/docker.sock` unix socket](https://medium.com/lucjuggery/about-var-run-docker-sock-3bfd276e12fd).

Hence a `dockerd` is started making the Docker API available for Jenkins builds (see [jenkins-slave](jenkins-slave) script).