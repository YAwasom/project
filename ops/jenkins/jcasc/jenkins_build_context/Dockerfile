# Latest lts version
ARG JENKINS_VERSION=alpine

FROM jenkins/jenkins:${JENKINS_VERSION}

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION
ARG JAVA_OPTS
ARG RUNNING_ON_LOCALHOST=false

LABEL maintainer="Warner Bros CMD" \
    org.label-schema.name="Warner Bros CMD Jenkins on ECS" \
    org.label-schema.description="Warner Bros CMD Jenkins on ECS" \
    org.label-schema.usage="/README.md" \
    org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
    org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.schema-version=$SCHEMA_VERSION

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false \
    -Dhudson.diyChunking=false \
    -Daws.region=${AWS_REGION} \
    -Dfile.encoding=UTF-8 \
    -Djavax.net.ssl.trustStore=/etc/ssl/certs/keystore/cacerts \
    -Dorg.eclipse.jetty.server.Request.maxFormContentSize=100000000 \
    -Dhudson.slaves.NodeProvisioner.initialDelay=0 \
    -Dhudson.slaves.NodeProvisioner.MARGIN=50 \
    -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85 \
    -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/Los_Angeles ${JAVA_OPTS:-}"

ENV JENKINS_REF /usr/share/jenkins/ref
# https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/README.md
ENV CASC_JENKINS_CONFIG ${JENKINS_REF}/casc_configs
# https://github.com/bambora/configuration-as-code-secret-ssm-plugin/blob/master/README.md
ENV CASC_SSM_PREFIX "/com/warnerbros/cmd/ops/jenkins/"

ENV GLIBC_VER=2.32-r0

# Install jenkins plugins
COPY plugins.txt $JENKINS_REF/plugins.txt
RUN /usr/local/bin/install-plugins.sh < $JENKINS_REF/plugins.txt

# Bootstrap for jenkins home
COPY dsl/* $JENKINS_REF/dsl/
COPY dsl/boot_seed_sync/* $JENKINS_REF/dsl/boot_seed_sync/
COPY shell/* $JENKINS_REF/shell/
COPY userContent/* $JENKINS_REF/userContent/
COPY jobs/* $JENKINS_REF/jobs/
COPY init.groovy.d/* $JENKINS_REF/init.groovy.d/
COPY casc_configs/* $CASC_JENKINS_CONFIG/
COPY comodo_root_ca.pem /etc/ssl/certs/keystore/

USER root

# Install the basics
RUN set -xe \
    && apk add --no-cache --purge -uU \
        docker \
        ca-certificates \
        less \
        maven \
        make \
        python3 \
        binutils \
        curl \
    && apk --update add --virtual .build-dependencies python3-dev libffi-dev openssl-dev build-base cmd:pip3 \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache --upgrade \
      boto3 \
    && apk del --purge .build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/*

# Install glibc compatibility for alpine, required for aws cli v2
RUN curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/* /tmp/*

# Install aws cli v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples

# Install yq
RUN curl -LJO "https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64" \
    && mv yq_linux_amd64 /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq


# Handles localhost vs remote development to navigate around saml auth
RUN ./${JENKINS_REF}/shell/localhost-casc.sh ${RUNNING_ON_LOCALHOST}
RUN chown -R jenkins:jenkins $CASC_JENKINS_CONFIG
RUN chown -R jenkins:jenkins /etc/ssl/certs/keystore/

USER jenkins

# Carry over ENTRYPOINT from jenkins/jenkins:${JENKINS_VERSION}
ENTRYPOINT ["/bin/bash", "-c", "/sbin/tini -- /usr/local/bin/jenkins.sh"]
