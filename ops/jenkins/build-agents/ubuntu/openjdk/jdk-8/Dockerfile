FROM ubuntu:20.04

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

LABEL maintainer="Warner Bros" \
  org.label-schema.name="ubuntu openjdk 8" \
  org.label-schema.description="ubuntu openjdk 8" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION

RUN apt-get update \
    && apt-get -y install openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java
ENV PATH $JAVA_HOME/bin:$PATH
