ARG AWS_REGION=us-west-2
ARG AWS_ACCOUNT_ID=348180535083

FROM $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/cmd/jenkins-amz2-jnlp-slave-base:latest

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins alpine jnlp slave with docker in docker support for nest" \
  org.label-schema.description="jenkins apline jnlp slave with docker in docker support for nest" \
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

# Install required packages
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community > /etc/apk/repositories \
    && echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
    &&  apk upgrade --available && apk add --no-cache \
    python3@edge \
    libstdc++@edge \
    chromium@edge \
    chromium-chromedriver@edge \
    harfbuzz@edge \
    nss@edge \
    freetype@edge \
    ttf-freefont@edge \
    firefox-esr@edge \
    xvfb@edge \
    zip@edge \
    go@edge \
    yarn@edge \
    ca-certificates@edge \
    wget@edge \
    ncurses5@edge \
    ncurses5-libs@edge \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk

# Install Microsoft Fonts
RUN apk --no-cache add msttcorefonts-installer@edge fontconfig@edge && \
    update-ms-fonts && \
    fc-cache -f

# Install node hack for maven frontend-maven-plugin:1.7.6:npm issues on alpine
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
    apk add glibc-2.28-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-bin-2.28-r0.apk && \
    apk add glibc-bin-2.28-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-i18n-2.28-r0.apk && \
    apk add glibc-i18n-2.28-r0.apk

USER jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
