## Deploy


- Nexus KMS
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-kms-nexus templates/ops.nexus.kms.yaml --file=parameters/ops.nexus.kms.yaml
```

- Nexus S3
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-s3-nexus templates/ops.nexus.s3.yaml --file=parameters/ops.nexus.s3.yaml
```

- Nexus ECR
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-ecr-nexus templates/ops.nexus.ecr.yaml --file=parameters/ops.nexus.ecr.yaml
```

- Nexus ECS
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-ecs-nexus templates/ops.nexus.ecs.yaml --file=parameters/ops.nexus.ecs.yaml
``` 

- Nexus DNS
  - wb-cmd-ops-{service}-{application}
```bash
simple-cfn deploy wb-cmd-ops-dns-nexus templates/ops.nexus.dns.yaml --file=parameters/ops.nexus.dns.yaml
```