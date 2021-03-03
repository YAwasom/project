FROM alpine:3.11

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTNG_VERSION 3.9
ENV JENKINS_GROUP 1000
ENV TERRAFORM_VERSION=0.12.24

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins alpine jnlp infra build tools slave" \
  org.label-schema.description="jenkins alpine jnlp infra build tools slave" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

RUN set -xe \
    && apk add --no-cache --purge -uU \
        bash \
        cargo \
        curl \
        git \
        g++ \
        go \
        jq \
        less \
        maven \
        make \
        unzip \
        nodejs \
        nodejs-npm \
        openjdk8 \
        openssh-client \
        python3 \
        rust \
    && apk --update add --virtual .build-dependencies python3-dev libffi-dev openssl-dev build-base \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache --upgrade awscli cfn-lint cfn_flip yamllint c7n c7n-org \
    && npm install -g serverless@1.67.0 aws-sdk \
    && apk del --purge .build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/*

# Install yq
RUN curl -LJO "https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64" \
    && mv yq_linux_amd64 /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Install terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/

# install cfn-guard from source
RUN git clone https://github.com/aws-cloudformation/cloudformation-guard.git && \
    cd cloudformation-guard && \
    make release_with_binaries && \
    cp target/release/cfn-guard /usr/local/bin/ && \
    cp target/release/cfn-guard-rulegen /usr/local/bin/

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