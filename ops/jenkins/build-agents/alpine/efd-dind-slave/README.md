# jenkins amazon linux jnlp slave

## Description

Based on [jenkins/slave/ Dockerfile](https://hub.docker.com/r/jenkins/slave/dockerfile) and
[jenkins/jnlp-slave/ Dockerfile](https://hub.docker.com/r/jenkins/jnlp-slave/dockerfile).

It seeks to maintain a general jenkins slave image that as a number of common utilities pre-installed.

Includes Java 8 via Amazon Corretto, PHP, and the Jenkins agent executable (slave.jar). This executable is an instance of the [Jenkins Remoting library](https://github.com/jenkinsci/remoting).

## Usage

This image is used as the basis for the [jenkins amazon linux 2 jnlp agent](../jnlp-slave/README.md) image.
In that image, the container is launched externally and attaches to Jenkins.

### Agent Work Directories

Starting from [Remoting 3.8](https://github.com/jenkinsci/remoting/blob/master/CHANGELOG.md#38) there is a support of Work directories, which provides logging by default and change the JAR Caching behavior.

Call example:

```sh
docker run -i --rm --name agent1 --init -v agent1-workdir:/home/jenkins/agent cmd/jenkins-amazonlinux2-jnlp-slave-base java -jar /usr/share/jenkins/slave.jar -workDir /home/jenkins/agent
```
