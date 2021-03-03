FROM alpine:3.10

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTNG_VERSION 3.9
ENV JENKINS_GROUP 1000

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins alpine jnlp vis slave" \
  org.label-schema.description="jenkins alpine jnlp vis slave" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

RUN set -xe \
    && apk add --no-cache --purge -uU \
        bash \
        curl \
        git \
        g++ \
        less \
        maven \
        make \
        nodejs \
        nodejs-npm \
        openjdk8 \
        openssh-client \
        python3 \
    && apk --update add --virtual .build-dependencies python3-dev libffi-dev openssl-dev build-base \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache --upgrade awscli \
    && npm install -g serverless@1.52.0 aws-sdk \
    && apk del --purge .build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/*

#Chrome browser to run the tests
RUN apk update && apk add --no-cache chromium

#Chrome web driver
RUN apk update && apk add --upgrade chromium-chromedriver

# Add jenkins user
RUN addgroup -g $JENKINS_GROUP -S jenkins \
    && adduser -G jenkins -D -h $JENKINS_HOME -s /bin/bash -u $JENKINS_GROUP jenkins \
    && chmod a+rwx $JENKINS_HOME

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