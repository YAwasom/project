FROM ubuntu:18.04

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION
ARG USER=jenkins
ARG GROUP=jenkins
ARG UID=1000
ARG GID=1000
ARG AGENT_WORKDIR=/home/${USER}/agent

# Versions
ARG MAVEN_VERSION=3.6.2

ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTNG_VERSION 3.9
ENV JENKINS_GROUP 1008
ENV DOCKER_GROUP  497
ENV DOCKER_HOST unix:///var/run/docker.sock

ENV HOME /home/${USER}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

# Java
ENV MAVEN_ENV_PATH /opt/maven/bin
# Path
ENV DEFAULT_PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PATH ${MAVEN_ENV_PATH}:${DEFAULT_PATH}

RUN export PATH=$PATH

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins ubuntu jnlp slave with docker in docker support for nest" \
  org.label-schema.description="jenkins ubuntu jnlp slave with docker in docker support for nest" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

ENV DEBIAN_FRONTEND=noninteractive 

ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTNG_VERSION 3.9
ENV JENKINS_GROUP 1000
ENV DOCKER_GROUP  497
ENV DOCKER_HOST unix:///var/run/docker.sock

USER root

# Install required packages
RUN apt update \
    && apt install -y apt-transport-https \
    automake \
    bzip2 \
    ca-certificates \
    curl \
    git \
    gnupg-agent \
    jq \
    python3 \
    python3-pip \
    nodejs \
    npm \
    maven \
    openjdk-8-jdk \
    openssh-server \
    software-properties-common \
    sudo \
    groff \
    readline-common \
    tar \
    wget \
    libsqlite3-dev \
    coreutils \
    zlib1g \
    && rm -rf /var/lib/apt/list/*

# Install Maven
RUN wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp && \
  tar xf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt && \
  ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven

RUN if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
	pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 install awscli && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

# Install simple-cfn for cloudformation deployments
RUN npm install -g simple-cfn

# Install Docker from Docker Inc. repositories.
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  apt-key fingerprint 0EBFCD88 && \
  add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable" && \
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose \
  && rm -rf /var/lib/apt/list/*

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
# Add jenkins user and allow jenkins user to run as root
RUN addgroup --gid $DOCKER_GROUP  --system docker \
    && addgroup --gid $JENKINS_GROUP --system jenkins \
    && adduser --gid $JENKINS_GROUP --disabled-password --home $JENKINS_HOME --shell /bin/bash --uid $JENKINS_GROUP jenkins --debug \
    && adduser jenkins docker \
    && passwd -u jenkins \
    && chmod a+rwx $JENKINS_HOME \
    && echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/10-jenkins \
    && chmod 440 /etc/sudoers.d/10-jenkins

RUN mkdir -p /home/jenkins/.local/bin/ /home/jenkins/.cache/ /home/jenkins/.m2/ \
  && ln -s /usr/bin/pip /home/jenkins/.local/bin/pip \
  && chown -R jenkins:jenkins /home/jenkins/.local /home/jenkins/.cache/ /home/jenkins/.m2/

COPY jenkins-slave /usr/local/bin/jenkins-slave

# Install Jenkins Remoting agent
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTNG_VERSION/remoting-$JENKINS_REMOTNG_VERSION.jar \
    && chmod 755 /usr/share/jenkins /usr/local/bin/jenkins-slave \
    && chmod 644 /usr/share/jenkins/slave.jar

USER ${USER}

RUN export PATH=$PATH

RUN export MAVEN_OPTS="-Xss50M -Xmx4000M -XX:+CMSClassUnloadingEnabled"

RUN mkdir $HOME/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${USER}/.jenkins

VOLUME ${AGENT_WORKDIR}

WORKDIR /home/${USER}