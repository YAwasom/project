## Deploy

- Jenkins KMS
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-kms-jenkins templates/ops.jenkins.kms.yaml --file=parameters/ops.jenkins.kms.yaml
```

- Jenkins S3
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-s3-jenkins templates/ops.jenkins.s3.yaml --file=parameters/ops.jenkins.s3.yaml
```

- Jenkins ECR
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-ecr-jenkins templates/ops.jenkins.ecr.yaml --file=parameters/ops.jenkins.ecr.yaml
```

- Jenkins Roles
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-role-jenkins templates/ops.jenkins.role.yaml --file=parameters/ops.jenkins.role.yaml
```

- Jenkins ECS
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-ecs-jenkins templates/ops.jenkins.ecs.yaml --file=parameters/ops.jenkins.ecs.yaml
``` 

- Jenkins DNS
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-dns-jenkins templates/ops.jenkins.dns.yaml --file=parameters/ops.jenkins.dns.yaml
```

## Encrypted EBS volumes with autoscale groups
  
- Create KMS key in ops account

- Edit Cloudformation template to create service-linked-role

- Add service linked role to auto-scale group to cloudformation templates

- Deploy out cloudformation for the roles then the autoscale groups
  
- Add service linked role in key policy

- [Instance launch failure](https://docs.amazonaws.cn/en_us/autoscaling/ec2/userguide/ts-as-instancelaunchfailure.html#ts-as-instancelaunchfailure-12)

