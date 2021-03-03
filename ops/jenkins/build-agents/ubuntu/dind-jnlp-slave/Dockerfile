FROM ubuntu:18.04

# Install OpenJDK8
COPY --from=openjdk:8 /usr/local/openjdk-8 /usr/local/openjdk-8

# Set ENV variables to make switching JDKs easier & default to JDK8
ENV JDK_8 /usr/local/openjdk-8
ENV JDK_11 /usr/lib/jvm/java-11-openjdk-amd64
ENV JDK_11_PATH "$PATH"
ENV JAVA_HOME "${JDK_8}"
ENV PATH "${JAVA_HOME}/bin:$PATH"

ENV DOCKER_CHANNEL=stable \
        DOCKER_COMPOSE_VERSION=1.26.0 \
        DEBUG=false

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins ubuntu jnlp slave with docker in docker support" \
  org.label-schema.description="jenkins ubuntu jnlp slave with docker in docker support" \
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

ENV PACKER_VERSION=1.5.5 \
    PACKER_OSNAME=linux \
    PACKER_OSARCH=amd64 \
    PACKER_DEST=/usr/local/sbin
ENV PACKER_ZIPFILE=packer_${PACKER_VERSION}_${PACKER_OSNAME}_${PACKER_OSARCH}.zip

RUN apt update \
    && apt install -y apt-transport-https \
	ca-certificates \
	curl \
	git \
	groff \
  iptables \
	jq \
  lxc \
	nodejs \
	npm \
	openjdk-11-jdk \
	openssh-server \
	python3 \
	python3-pip \
	sudo \
  wget \
	zip \
	unzip \
    && rm -rf /var/lib/apt/list/*

RUN if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
	pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 install awscli && \
	if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

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

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Docker compose installation
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
        && chmod +x /usr/local/bin/docker-compose

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

CMD ["wrapdocker"]
