FROM amazon/aws-cli

WORKDIR /usr/src

RUN yum install -y \
    python3
    
COPY . .

RUN chmod +x /usr/src/AWSSecReport.sh

ENTRYPOINT ["/usr/src/AWSSecReport.sh"]