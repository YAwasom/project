# Deploy

- vpc
  - contentnow-vpc-dev
```bash
    simple-cfn deploy contentnow-vpc-dev templates/vpc.yaml --file=parameters/vpc/vpc.dev.yaml
```

- vpc
  - contentnow-vpc
```bash
    simple-cfn deploy contentnow-vpc templates/vpc.yaml --file=parameters/vpc/vpc.prod.yaml
```

- Subnets
  - wb-cn-{env}-subnet
```bash
    simple-cfn deploy wb-cn-stg-subnet templates/subnet.yaml --file=parameters/subnet/subnet.stg.yaml
```

- External Roles
  - wb-cn-live-search-vendor-role
  - wb-cn-live-search-non-prod-vendor-role
  - wb-cn-{env}-outbound-client-spec-role
```bash
    simple-cfn deploy wb-cn-live-search-vendor-role templates/role.external.search.yaml --file=parameters/role/role.external.search.yaml  

    simple-cfn deploy wb-cn-live-search-non-prod-vendor-role templates/role.external.search.non.prod.yaml --file=parameters/role/role.external.non.prod.search.yaml  
    
    simple-cfn deploy wb-cn-dev-outbound-client-spec-role templates/role.external.outbound.client.spec.yaml --file=parameters/outbound/role.external.outbound.client.spec.dev.yaml

    simple-cfn deploy wb-cn-qa-outbound-client-spec-role templates/role.external.outbound.client.spec.yaml --file=parameters/outbound/role.external.outbound.client.spec.qa.yaml

    simple-cfn deploy wb-cn-prod-outbound-client-spec-role templates/role.external.outbound.client.spec.yaml --file=parameters/outbound/role.external.outbound.client.spec.prod.yaml
```

- Deploy Roles
  - wb-cn-livesearch-deploy-{env}-jenkins-us-west-2
```bash
    simple-cfn deploy wb-cn-livesearch-deploy-dev templates/deploy.yaml --file=parameters/deploy/deploy.dev.yaml  

    simple-cfn deploy wb-cn-livesearch-deploy-qa templates/deploy.yaml --file=parameters/deploy/deploy.qa.yaml  

    simple-cfn deploy wb-cn-livesearch-deploy-stg templates/deploy.yaml --file=parameters/deploy/deploy.stg.yaml  

    simple-cfn deploy wb-cn-livesearch-deploy-prod templates/deploy.yaml --file=parameters/deploy/deploy.prod.yaml  
```

## Networking

### ContentNow Vpc ( 10.0.0.0/16 )

### ContentNow Prod
| Public       | Private      |
| ------------ | ------------ |
| 10.0.16.0/20 | 10.0.32.0/20 |
| 10.0.48.0/20 | 10.0.64.0/20 |

### ContentNow STG
| Public       | Private      |
| ------------ | ------------ |
| 10.0.96.0/23 | 10.0.92.0/23 |
| 10.0.98.0/23 | 10.0.94.0/23 |

### Eidr
| Public       | Private      |
| ------------ | ------------ |
| 10.0.86.0/23 | 10.0.80.0/23 |
| 10.0.88.0/23 | 10.0.82.0/23 |
| 10.0.90.0/23 | 10.0.84.0/23 |