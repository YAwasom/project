FROM docker:stable-dind

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION
ARG VERSION=3.28
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
  org.label-schema.name="jenkins alpine jnlp slave with docker in docker support for nest" \
  org.label-schema.description="jenkins apline jnlp slave with docker in docker support for nest" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

USER root

# Install required packages
RUN apk --update add \
    automake \
    build-base \
    bzip2 \
    curl \
    git \
    openjdk8 \
    nodejs \
    npm \
    maven \
    sudo \
    groff \
    openssh \
    readline \
    tar \
    jq \
    wget \
    sqlite-dev \
    ca-certificates \
    coreutils \
    zlib

# Install Maven
RUN wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp && \
  tar xf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt && \
  ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven

# Install python & awscli
RUN apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 install awscli && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

# Add jenkins user and allow jenkins user to run as root
RUN addgroup -g $DOCKER_GROUP  -S docker \
    && addgroup -g $JENKINS_GROUP -S jenkins \
    && adduser -G jenkins -D -h $JENKINS_HOME -s /bin/bash -u $JENKINS_GROUP jenkins \
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