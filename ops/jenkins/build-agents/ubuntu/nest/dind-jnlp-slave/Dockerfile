ARG AWS_REGION=us-west-2
ARG AWS_ACCOUNT_ID=348180535083

FROM $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/cmd/jenkins-ubuntu-jnlp-slave-base:latest

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins ubuntu jnlp slave with docker in docker support for nest" \
  org.label-schema.description="jenkins ubuntu jnlp slave with docker in docker support for nest" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

ENV CHROMEDRIVER_PORT 9515
ENV CHROMEDRIVER_WHITELISTED_IPS "127.0.0.1"
ENV CHROMEDRIVER_URL_BASE ''
ENV CHROMEDRIVER_EXTRA_ARGS ''

USER root

# Install utility to gracefully add non-Ubuntu repositories
RUN apt update && \
    apt install -y software-properties-common

# Install required packages
RUN add-apt-repository ppa:mozillateam/ppa && \
    apt update && \
    apt install -y \
    ca-certificates \
    chromium-browser\
    chromium-chromedriver \
    firefox-esr \
    libfreetype6 \
    libharfbuzz-dev \
    python3 \
    python-nss \
    ttf-ubuntu-font-family \
    wget \
    xvfb \
    yarn \
    zip \
    && rm -rf /var/lib/apt/list/*

# Install go
RUN wget -q https://storage.googleapis.com/golang/getgo/installer_linux && \
    chmod +x installer_linux && \
    sudo ./installer_linux && \
    sudo chown -R jenkins:jenkins .bash_profile .go && \
    sudo rm installer_linux && \
    export PATH=$PATH:/home/jenkins/.go/bin && \
    go version

USER jenkins

#ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
CMD ["wrapdocker"]