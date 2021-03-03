FROM ubuntu:20.04

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

LABEL maintainer="Warner Bros" \
  org.label-schema.name="ubuntu openjdk corretto 8" \
  org.label-schema.description="ubuntu openjdk corretto 8" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

ARG CORRETTO_VERSION=8.222.10.1
ARG CORRETTO_RPM=java-1.8.0-amazon-corretto-jdk_8.222.10-1_amd64.deb

RUN apt-get update \
    && apt-get -y install curl java-common \
    && curl -O https://d3pxv6yz143wms.cloudfront.net/$CORRETTO_VERSION/$CORRETTO_RPM \
    && dpkg --install $CORRETTO_RPM \
    && update-alternatives --config java \
    && update-alternatives --config javac \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java
ENV PATH $JAVA_HOME/bin:$PATH
