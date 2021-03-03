FROM docker:stable-dind

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTNG_VERSION 3.9
ENV JENKINS_GROUP 1000
ENV DOCKER_GROUP  497
ENV DOCKER_HOST unix:///var/run/docker.sock

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins alpine publish api jnlp slave with docker in docker support" \
  org.label-schema.description="jenkins apline publish api jnlp slave with docker in docker support" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

# Install required packages
RUN set -xe \
    && apk add --no-cache --purge -uU \
        bash \
        ca-certificates \
        coreutils \
        curl \
        g++ \
        less \
        git \
        openjdk8 \
        maven \
        make \
        nodejs \
        nodejs-npm \
        sudo \
        groff \
        openssh \
        openssh-client \
        python3 \
    && apk --update add --virtual .build-dependencies python3-dev libffi-dev openssl-dev build-base cmd:pip3 \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache --upgrade awscli \
    && apk del --purge .build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/*

# Add jenkins user and allow jenkins user to run as root
RUN addgroup -g $DOCKER_GROUP  -S docker \
    && addgroup -g $JENKINS_GROUP -S jenkins \
    && adduser -G jenkins -D -h $JENKINS_HOME -s /bin/bash -u $JENKINS_GROUP jenkins \
    && adduser jenkins docker \
    && passwd -u jenkins \
    && chmod a+rwx $JENKINS_HOME \
    && echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/10-jenkins \
    && chmod 440 /etc/sudoers.d/10-jenkins 

RUN mkdir -p /home/jenkins/.local/bin/ \
  && ln -s /usr/bin/pip /home/jenkins/.local/bin/pip \
  && chown -R jenkins:jenkins /home/jenkins/.local

COPY jenkins-slave /usr/local/bin/jenkins-slave

# Install Jenkins Remoting agent
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTNG_VERSION/remoting-$JENKINS_REMOTNG_VERSION.jar \
    && chmod 755 /usr/share/jenkins /usr/local/bin/jenkins-slave \
    && chmod 644 /usr/share/jenkins/slave.jar

VOLUME $JENKINS_HOME
WORKDIR $JENKINS_HOME

USER jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
