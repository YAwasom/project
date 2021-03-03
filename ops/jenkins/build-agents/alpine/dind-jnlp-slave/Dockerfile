FROM docker:stable-dind

# Install OpenJDK8
COPY --from=openjdk:8-alpine /usr/lib/jvm/java-1.8-openjdk /usr/lib/jvm/java-1.8-openjdk

# Set ENV variables to make switching JDKs easier & default to JDK8
# Use in a Jenkinsfile like:
# environment {
#      JAVA_HOME = "${JDK_11}"
#      PATH = "${JDK_11_PATH}"
# }
ENV JDK_8 /usr/lib/jvm/java-1.8-openjdk
ENV JDK_11 /usr/lib/jvm/java-11-openjdk
ENV JDK_11_PATH "$PATH"
ENV JAVA_HOME "${JDK_8}"
ENV PATH "${JAVA_HOME}/bin:$PATH"

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTNG_VERSION 3.9
ENV JENKINS_GROUP 1000
ENV DOCKER_GROUP  497
ENV DOCKER_HOST unix:///var/run/docker.sock

ENV PACKER_VERSION=1.6.5 \
    PACKER_OSNAME=linux \
    PACKER_OSARCH=amd64 \
    PACKER_DEST=/usr/local/sbin
ENV PACKER_ZIPFILE=packer_${PACKER_VERSION}_${PACKER_OSNAME}_${PACKER_OSARCH}.zip

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins alpine jnlp slave with docker in docker support" \
  org.label-schema.description="jenkins apline jnlp slave with docker in docker support" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

# Install required packages
RUN apk --update add \
    curl \
    bash \
    build-base \
    docker-compose \
    git \
    openjdk11 \
    nodejs \
    npm \
    maven \
    sudo \
    zip \
    unzip \
    tar \
    jq \
    groff \
    openssh \
    ca-certificates \
    coreutils

# Install packer
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_ZIPFILE} ${PACKER_DEST}/

RUN unzip ${PACKER_DEST}/${PACKER_ZIPFILE} -d ${PACKER_DEST} && \
    rm -rf ${PACKER_DEST}/${PACKER_ZIPFILE}

# Install yq
RUN curl -LJO "https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64" \
    && mv yq_linux_amd64 /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Install simple-cfn for cloudformation deployments
RUN npm install -g simple-cfn

# Install python & awscli
RUN apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 install boto3 awscli && \
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
