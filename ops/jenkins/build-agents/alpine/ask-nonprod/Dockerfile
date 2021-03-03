FROM docker:stable-dind

ARG BUILD_DATE
ARG VCS_REF
ARG SCHEMA_VERSION

ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTNG_VERSION 3.9
ENV JENKINS_GROUP 1000
ENV DOCKER_GROUP  497
ENV DOCKER_HOST unix:///var/run/docker.sock

LABEL maintainer="Warner Bros" \
  org.label-schema.name="jenkins alpine jnlp ask-nonprod slave" \
  org.label-schema.description="jenkins alpine jnlp ask-nonprod slave" \
  org.label-schema.usage="/README.md" \
  org.label-schema.url="https://github.com/wm-msc-malt/infrastructure" \
  org.label-schema.vcs-url="git@github.com:wm-msc-malt/infrastructure.git" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.schema-version=$SCHEMA_VERSION


# Install required packages
RUN apk --update add \
    build-base \
    git \
    openjdk8 \
    maven \
    sudo \
    groff \
    openssh \
    ca-certificates \
    coreutils \
    php7 \
    php7-cli \
    php7-json \
    php7-phar \
    php7-mbstring \
    php7-iconv \
    php7-openssl \
    php7-fpm \
    php7-mbstring \
    php7-xml \
    php7-simplexml \
    php7-tokenizer \
    php7-xmlwriter \
    php7-curl \
    php7-xml \
    php7-dom \
    php7-dev \
    php7-fileinfo \
    php7-pdo \
    php7-soap \
    libxml2 \
    libmcrypt-dev \
    php7-pear \
    curl \
    unzip \
    git 

RUN pear config-set php_ini /etc/php7/php.ini \   
    && pecl install mcrypt-1.0.3 \
    #&& echo "extension=mcrypt.so" >> /etc/php7/php.ini

#fixiconv
RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

#    && docker-php-ext-install -j$(nproc) iconv gd mbstring zip pdo_mysql \
#    && docker-php-ext-enable pdo_mysql

#Install composer for ASK
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN mv composer.phar /usr/local/bin/composer
RUN php -r "unlink('composer-setup.php');"

# Install python & awscli
RUN apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 install awscli && \
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