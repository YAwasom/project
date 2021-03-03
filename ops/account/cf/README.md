## Deploy

- Ops VPC
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-vpc templates/ops.vpc.yaml --file=parameters/ops.vpc.yaml
```

- Ops NACL
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-nacl templates/ops.nacl.yaml --file=parameters/ops.nacl.yaml
```

- Ops DNS
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-dns templates/ops.dns.yaml --file=parameters/ops.dns.yaml
```

- Ops ECR
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-ecr templates/ops.ecr.yaml --file=parameters/ops.ecr.yaml

simple-cfn deploy wb-cmd-ops-ecr-2 templates/ops.ecr2.yaml --file=parameters/ops.ecr.yaml
```

- Ops IAM
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-iam templates/ops.iam.yaml --file=parameters/ops.iam.yaml
```

- OPS IAM STS Groups
  - wb-cmd-ops-iam-sts-groups

```bash
simple-cfn deploy wb-cmd-ops-iam-sts-groups ops.iam.sts.yaml
```

- Ops Role
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-role templates/ops.role.yaml --file=parameters/ops.role.yaml
```

- Ops KMS
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-kms templates/ops.kms.yaml --file=parameters/ops.kms.yaml
```

- Ops S3
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-s3 templates/ops.s3.yaml --file=parameters/ops.s3.yaml
```

- Ops SNS
  - wb-cmd-ops-{service}-{application}

```bash
simple-cfn deploy wb-cmd-ops-sns templates/ops.sns.yaml --file=parameters/ops.sns.yaml
```

- Ops SSM
  - wb-cmd-ops-ssm

```bash
simple-cfn deploy wb-cmd-ops-ssm templates/ops.ssm.yaml
```

- Ops WAF
  - wb-cmd-ops-waf

```bash
simple-cfn deploy wb-cmd-ops-waf templates/ops.waf.yaml
```
