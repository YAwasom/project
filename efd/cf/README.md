# Deploy

## Terraform Backend S3 & DynamoDB
  - efd-{env}-s3
  - efd-{env}-dynamodb
```bash
  simple-cfn deploy efd-dev-tf-s3 templates/tf.s3.yaml --file=parameters/s3/s3.tf.dev.yaml
  simple-cfn deploy efd-stg-tf-s3 templates/tf.s3.yaml --file=parameters/s3/s3.tf.dev.yaml
  simple-cfn deploy efd-prod-tf-s3 templates/tf.s3.yaml --file=parameters/s3/s3.tf.dev.yaml
  
  simple-cfn deploy efd-dev-tf-dynamodb templates/tf.dynamodb.yaml --file=parameters/dynamodb/dynamodb.tf.dev.yaml
  simple-cfn deploy efd-stg-tf-dynamodb templates/tf.dynamodb.yaml --file=parameters/dynamodb/dynamodb.tf.dev.yaml
  simple-cfn deploy efd-prod-tf-dynamodb templates/tf.dynamodb.yaml --file=parameters/dynamodb/dynamodb.tf.dev.yaml

# Deploying CloudFormation

The recommend approach is to use [simple-cfn](https://www.npmjs.com/package/simple-cfn).

Parameter configurations are stored under the [cf/parameters](./cf/parameters) directory.

```bash
simple-cfn deploy <stack-name> /path/<template-name>.yaml --file=parameters/path/{service}.{env}.yml
```

## Infrastructure NOT in CloudFormation

- MongoDB cluster configuration(https://docs.mongodb.com/manual/reference/configuration-options/)
- Route53 for efd-rds.prod.mars.warnerbros.com pointing to rds DNS endpoint

## Deploy (in-order)

- EFD VPC
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-dev-vpc1 templates/efd.vpc.yaml --file=parameters/vpc/vpc.dev.yaml
```

- EFD NACL
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-nacl templates/efd.nacl.yaml --file=parameters/nacl/nacl.prod.yaml
```

- EFD KMS
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-kms templates/efd.kms.yaml --file=parameters/kms/kms.prod.yaml
```

- EFD S3
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod1-s3 templates/efd.s3.yaml --file=parameters/s3/s3.prod.yaml
```

- EFD SQS
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-sqs templates/efd.sqs.yaml --file=parameters/sqs/sqs.prod.yaml
```

- EFD SNS
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-sns templates/efd.sns.yaml --file=parameters/sns/sns.prod.yaml
```

- EFD Role
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-role templates/efd.role.yaml --file=parameters/role/role.prod.yaml
simple-cfn deploy efd-dev-rds-role templates/efd.rds.role.yaml --file=parameters/role/role.dev.yaml
simple-cfn deploy efd-stg-rds-role templates/efd.rds.role.yaml --file=parameters/role/role.stg.yaml
simple-cfn deploy efd-prod-rds-role templates/efd.rds.role.yaml --file=parameters/role/role.prod.yaml

```

- EFD Jenkins Deploy Role
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-dev-jenkins-deploy templates/deploy.yaml --file=parameters/deploy/deploy.dev.yaml
simple-cfn deploy efd-stg-jenkins-deploy templates/deploy.yaml --file=parameters/deploy/deploy.stg.yaml
simple-cfn deploy efd-prod-jenkins-deploy templates/deploy.yaml --file=parameters/deploy/deploy.prod.yaml

```

- EFD SG
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-sg1 templates/efd.sg.yaml --file=parameters/sg/sg.prod.yaml
``` 

- EFD NLB
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-nlb1 templates/efd.nlb.yaml --file=parameters/nlb/nlb.prod.yaml
```

- EFD EC2
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-ec2-1b templates/efd.ec2.yaml --file=parameters/ec2/ec2.prod.yaml
```

- EFD RDS
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-rds templates/efd.rds.yaml --file=parameters/rds/rds.prod.yaml
simple-cfn deploy efd-stg-rds-restore templates/efd.rdsrestore.yaml --file=parameters/rdsrestore/rds.stg.yaml
simple-cfn deploy efd-prod-rds-restore templates/efd.rdsrestore.yaml --file=parameters/rdsrestore/rds.prod.yaml
```
  - Update Route53 CNAME with new RDS endpoint


- EFD EFS
  - efd-dev-{service}-{application}
```bash
simple-cfn deploy efd-prod-efs templates/efd.efs.yaml --file=parameters/efs/efs.prod.yaml
```
- Validate CFN template 
  - Change directory to template 
```bash
cd template
aws cloudformation validate-template --template-body file://efd.role.yaml
```
- App deployment - this will be perdomed through Jenkins CICD pipeline 
  Repo (https://github.com/wm-msc-malt//efdawsmigration)
    - Run following command in base folder
```bash
 mvn clean install -DskipTests
```
    -After successful competition of build job
      - Surly Web Service Deployment

```bash
aws s3 cp "./mars-surly-ws/target/static-url-ws.war" s3://efd-${environment}-s3-code-repository/appwar/surlyserver/static-url-ws.war
```
   -EFD Download Web Service / Notification Service / BlitLine WebService Deployment
```bash
aws s3 cp   "./mars-efd-ws/target/mars-efd-ws.war"  s3://efd-${environment}-s3-code-repository/appwar/appserver/mars-efd-ws.war
aws s3 cp "./mars-efd-notification-servic/target/mars-efd-notification-service-0.0.1-SNAPSHOT.war" 3://efd-${environment}-s3-code-repository/EFDNotification/mars-efd-notification-service-0.0.1-SNAPSHOT.war
aws s3 cp "./mars-efd-blitline-ws/target/mars-efd-blitline-ws-0.0.1.war" s3://efd-${environment}-s3-code-repository/appwar/appserver/mars-efd-blitline-ws-0.0.1.war
```
   - Flux JAR deployment
```bash
aws s3 cp "./mars-efd-distributor-java/target/lib/*" ss3://efd-${environment}-s3-code-repository/FluxJars/Lib/mars-efd-blitline-ws-0.0.1.war
```
 
- Flux instance build 
```bash
        -Create user marsadm 
        -Download Flux-7-11-5 package from flux console (https://support.flux.ly/) and place it in /data/apps/ folder in flux server
        -Edit setenv.sh to set java path
        -update route53 to resolve IP to fqdn
        -Run flux.jar using “java -jar flux.jar” command
        -Now run make-war.sh to extract the contents of flux.war.
        -Copy new flux license key to /data/apps/flux-7-11-5 directory
        -Update hostname in /usr/share/tomcat/.flux
        -Run configuration.sh to read flux key from fluxkey-7-11.txt
        -Run start-agent.sh, start-engine.sh, start-opsconsole.sh.
        -Login to admin console and choose engine 
        -Now login to flux using default username and password(admin)
        -Change default credentials 
        - Note:- All above steps are completed in AMI ID :- !Ref FluxServerImageID )ec2 parameter
               and userdata is configured to pull latest war file from s3 post build
```
- S3 buckets for the war files 
```bash
        - S3 bucket for the war files 
            dev > efd-dev-s3-code-repository
          stage > efd-stg-s3-code-repository
           Prod > efd-prod-s3-code-repository
```
