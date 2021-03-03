# openjdk on ubuntu

## Supported tags and respective Dockerfile links

## Corretto

* jdk-8-corretto, 8 [jdk-8-corretto/Dockerfile](https://github.com/wm-msc-malt/infrastructure/blob/develop/ops/jenkins/build-agents/ubuntu/openjdk/jdk-8-corretto/Dockerfile)
* jdk-11-corretto, 11 [jdk-11-corretto/Dockerfile](https://github.com/wm-msc-malt/infrastructure/blob/develop/ops/jenkins/build-agents/ubuntu/openjdk/jdk-11-corretto/Dockerfile)

## OpenJDK

* jdk-8, 8 [jdk-8/Dockerfile](https://github.com/wm-msc-malt/infrastructure/blob/develop/ops/jenkins/build-agents/ubuntu/openjdk/jdk-8/Dockerfile)
* jdk-11, 11 [jdk-11/Dockerfile](https://github.com/wm-msc-malt/infrastructure/blob/develop/ops/jenkins/build-agents/ubuntu/openjdk/jdk-11/Dockerfile)

## Building & Release

```bash
# Directory name as version
make all version=jdk-*
```

## Running

```bash
docker run -it 348180535083.dkr.ecr.us-west-2.amazonaws.com/cmd/ubuntu-openjdk:jdk-8 /bin/bash
docker run -it 348180535083.dkr.ecr.us-west-2.amazonaws.com/cmd/ubuntu-openjdk:jdk-11 /bin/bash
docker run -it 348180535083.dkr.ecr.us-west-2.amazonaws.com/cmd/ubuntu-openjdk:jdk-8-corretto /bin/bash
docker run -it 348180535083.dkr.ecr.us-west-2.amazonaws.com/cmd/ubuntu-openjdk:jdk-11-corretto /bin/bash
```

```bash
docker run -it cmd/ubuntu-openjdk:jdk-8 /bin/bash
docker run -it cmd/ubuntu-openjdk:jdk-11 /bin/bash
docker run -it cmd/ubuntu-openjdk:jdk-8-corretto /bin/bash
docker run -it cmd/ubuntu-openjdk:jdk-11-corretto /bin/bash
```
