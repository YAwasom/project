install security groups
simple-cfn deploy blitline-prod-sg ./sg.yml --file ../config/sg/sg.prod.yml

install peripherals
simple-cfn deploy blitline-prod-peripherals ./peripherals.yml --file ../config/peripherals/peripherals.prod.yml

install iam
simple-cfn deploy blitline-dev-iam ./iam.yml --file ../config/iam/iam.dev.yml
simple-cfn deploy blitline-qa-iam ./iam.yml --file ../config/iam/iam.qa.yml
simple-cfn deploy blitline-stg-iam ./iam.yml --file ../config/iam/iam.stg.yml
simple-cfn deploy blitline-prod-iam ./iam.yml --file ../config/iam/iam.prod.yml

install iam
simple-cfn deploy blitline-dev-lb ./lb.yml --file ../config/lb/lb.dev.yml
simple-cfn deploy blitline-qa-lb ./lb.yml --file ../config/lb/lb.qa.yml
simple-cfn deploy blitline-stg-lb ./lb.yml --file ../config/lb/lb.stg.yml
simple-cfn deploy blitline-prod-lb ./lb.yml --file ../config/lb/lb.prod.yml

# EC2

setup Web EC2 ASG
simple-cfn deploy blitline-dev-web-servers ./ec2.yml --file ../config/web/web.dev.yml
simple-cfn deploy blitline-qa-web-servers ./ec2.yml --file ../config/web/web.qa.yml
simple-cfn deploy blitline-stg-web-servers ./ec2.yml --file ../config/web/web.stg.yml
simple-cfn deploy blitline-prod-web-servers ./ec2.yml --file ../config/web/web.prod.yml

setup Microservices EC2 ASG
simple-cfn deploy blitline-dev-ms-servers ./ec2.yml --file ../config/ms/ms.dev.yml
simple-cfn deploy blitline-qa-ms-servers ./ec2.yml --file ../config/ms/ms.qa.yml
simple-cfn deploy blitline-stg-ms-servers ./ec2.yml --file ../config/ms/ms.stg.yml
simple-cfn deploy blitline-prod-ms-servers ./ec2.yml --file ../config/ms/ms.prod.yml

setup Worker EC2 ASG

simple-cfn deploy blitline-dev-worker-servers ./worker-sandbox.ec2.yml --file ../config/worker/worker.dev.yml
simple-cfn deploy blitline-qa-worker-servers ./worker-sandbox.ec2.yml --file ../config/worker/worker.qa.yml
simple-cfn deploy blitline-stg-worker-servers ./worker-sandbox.ec2.yml --file ../config/worker/worker.stg.yml
simple-cfn deploy blitline-prod-worker-servers ./worker-sandbox.ec2.yml --file ../config/worker/worker.prod.yml

setup Sandbox EC2 ASG
simple-cfn deploy blitline-dev-sandbox-servers ./worker-sandbox.ec2.yml --file ../config/sandbox/sandbox.dev.yml
simple-cfn deploy blitline-qa-sandbox-servers ./worker-sandbox.ec2.yml --file ../config/sandbox/sandbox.qa.yml
simple-cfn deploy blitline-stg-sandbox-servers ./worker-sandbox.ec2.yml --file ../config/sandbox/sandbox.stg.yml
simple-cfn deploy blitline-prod-sandbox-servers ./worker-sandbox.ec2.yml --file ../config/sandbox/sandbox.prod.yml

# ECS

setup microservices ecs cluster
simple-cfn deploy blitline-dev-ms-ecs ./ms.ecs.yml --file ../config/ms/ms.dev.yml
simple-cfn deploy blitline-qa-ms-ecs ./ms.ecs.yml --file ../config/ms/ms.qa.yml
simple-cfn deploy blitline-stg-ms-ecs ./ms.ecs.yml --file ../config/ms/ms.stg.yml
simple-cfn deploy blitline-prod-ms-ecs ./ms.ecs.yml --file ../config/ms/ms.prod.yml

setup web ecs cluster
simple-cfn deploy blitline-dev-web-ecs ./web.ecs.yml --file ../config/web/web.dev.yml
simple-cfn deploy blitline-qa-web-ecs ./web.ecs.yml --file ../config/web/web.qa.yml
simple-cfn deploy blitline-stg-web-ecs ./web.ecs.yml --file ../config/web/web.stg.yml
simple-cfn deploy blitline-prod-web-ecs ./web.ecs.yml --file ../config/web/web.prod.yml

setup worker ecs cluster
simple-cfn deploy blitline-dev-worker-ecs ./worker.ecs.yml --file ../config/worker/worker.dev.yml
simple-cfn deploy blitline-qa-worker-ecs ./worker.ecs.yml --file ../config/worker/worker.qa.yml
simple-cfn deploy blitline-stg-worker-ecs ./worker.ecs.yml --file ../config/worker/worker.stg.yml
simple-cfn deploy blitline-prod-worker-ecs ./worker.ecs.yml --file ../config/worker/worker.prod.yml

setup worker ecs cluster
simple-cfn deploy blitline-dev-sandbox-ecs ./sandbox.ecs.yml --file ../config/sandbox/sandbox.dev.yml
simple-cfn deploy blitline-qa-sandbox-ecs ./sandbox.ecs.yml --file ../config/sandbox/sandbox.qa.yml
simple-cfn deploy blitline-stg-sandbox-ecs ./sandbox.ecs.yml --file ../config/sandbox/sandbox.stg.yml
simple-cfn deploy blitline-prod-sandbox-ecs ./sandbox.ecs.yml --file ../config/sandbox/sandbox.prod.yml

# Autoscaling Alerting

setup sandbox alerting
simple-cfn deploy blitline-dev-sandbox-servers-alerts ec2-alerts.yml --file=../config/sandbox/sandbox.dev.yml 
simple-cfn deploy blitline-qa-sandbox-servers-alerts ec2-alerts.yml --file=../config/sandbox/sandbox.qa.yml 
simple-cfn deploy blitline-stg-sandbox-servers-alerts ec2-alerts.yml --file=../config/sandbox/sandbox.stg.yml 
simple-cfn deploy blitline-prod-sandbox-servers-alerts ec2-alerts.yml --file=../config/sandbox/sandbox.prod.yml 

setup worker alerting
simple-cfn deploy blitline-dev-worker-servers-alerts ec2-alerts.yml --file=../config/worker/worker.dev.yml 
simple-cfn deploy blitline-qa-worker-servers-alerts ec2-alerts.yml --file=../config/worker/worker.qa.yml 
simple-cfn deploy blitline-stg-worker-servers-alerts ec2-alerts.yml --file=../config/worker/worker.stg.yml 
simple-cfn deploy blitline-prod-worker-servers-alerts ec2-alerts.yml --file=../config/worker/worker.prod.yml 

# SNS lambda
serverless deploy --stage dev
serverless deploy --stage qa
serverless deploy --stage stg
serverless deploy --stage prod


# Notes on how this stuff works

- Jason pubs to his ecr.. we pull that image via ecr.sh and push into our account
- 10 or so docker images that each contain portions services (magick, exiftool,etc)
- Have to bounce the ECS cluster to do deploys
- web, workers, microservices, sandbox with an alb to front everything

- web task 
  - memcache
  - allq (local proxy which goes to microservices or other ecs clusters)
    - basically redis with inter-networking between ecs clusters
    - this is the client proxy
    - deployed on all all the ecs clusters
    - talks to microservices ecs cluster
    - web might check long poll, then check allq and route to microservices
  - long poll (really a cache for poll statues)
  - web (api, heavy lifting)
    - only has info of 

- Microservices ecs cluster 
  - contains queues of all running jobs
  - workers pull from here
  - sandbox pulls from here
  - allq service that acts as sqs

- workers 
  - just interrogate the microservices cluster to get items off the queues
    - background (background removal program)
    - batik (java, svg files)
    - tika (text extraction)
    - memcached
    - magick
    - gs
    - blitline worker (main, which is the router and for file type processing, s3 as temp store)
      - signals back to the microservices ecs for status updates
    - us_queue (allq client)

- sandbox
  - worker but for dangerous stuff
  - api supports full convert commandline operations
  - controller (the router)
  - allq client


- S3 Buckets
  - shortlife (not sure what this is)
  - shortlife private (not sure what this is)
  - stores finished item from the transcode..possibly pushes it to a target bucket

- video is handled separately via elastic encoder]
  - uses sns to get back to the web

- TODO
  - autoscaling on the microsevices cluster
    - alert on ram
    - ideally figure out a way to persist
  - microservices when scaling does know about the other queuing
  - web cluster
    - make long poll cache persistent
    - alerts on memory too

# Testing Blitline in NonProd:

For the following steps to work, AWS CLI and the Session Manager plugin must be installed and configured for SSH on your local machine. 

**See:** 
* https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html 
* https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html 

Additionally, you must have a .pem key installed for contentnow-nonprod. Please see #pit-dev-ops to request one. 

`ssh -i ~/.ssh/<pem-key-name*>.pem -L 3000:vpce-0e55f97caf4712359-uo2py2ym-us-west-2a.vpce-svc-0d30799844ac12ad2.us-west-2.vpce.amazonaws.com:80 ubuntu@<instance-id*>` 

* pem-key-name - name of the pem key received from devops. \ 
* instance-id - instance id for instance running blitline-web-qa (ex: i-02d84c3fa6c54632f) \
