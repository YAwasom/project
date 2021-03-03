FROM sonatype/nexus3:3.29.2

COPY entry-point /usr/local/bin/

# Become the root user
USER root

# Install Python for AWS CLI
RUN yum -y --disableplugin=subscription-manager update \
    && yum -y install --disableplugin=subscription-manager python3-pip git \
    && pip3 install awscli

# Install Tini - tiny init
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Install gosu (Credits: https://git.io/vpcMB)
ARG GOSU_VERSION=1.11
RUN gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

# SONATYPE_DIR is inherited from base container
ARG START_SCRIPT="${SONATYPE_DIR}/start-nexus-repository-manager.sh"

# Get around moby limitation (https://github.com/moby/moby/issues/18492) since ENTRYPOINT will not evaluate ${YOUR_ARG}
RUN ln -s ./${START_SCRIPT} executable.sh
RUN chmod +x ./executable.sh
ENTRYPOINT ["/usr/local/bin/entry-point", "/tini", "--", "./executable.sh"]