# Ops github runner

## EC2 spot gold packer ami grant

`arn:aws:iam::348180535083:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot` is given permissions in the `wb-cmd-ops-kms-gold-packer` kms key policy

```bash
aws kms create-grant \
    --region us-west-2 \
    --name "ops-us-west-2-github-runner-dev-kms-spot-grant" \
    --key-id arn:aws:kms:us-west-2:348180535083:key/a370c4f2-5a11-4a3e-a5fa-3a5bc7ce659c \
    --grantee-principal arn:aws:iam::348180535083:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot \
    --operations "Decrypt" "Encrypt" "GenerateDataKey" "GenerateDataKeyWithoutPlaintext" "CreateGrant" "DescribeKey" "ReEncryptFrom" "ReEncryptTo"
```

```json
{
  "KeyId": "arn:aws:kms:us-west-2:348180535083:key/a370c4f2-5a11-4a3e-a5fa-3a5bc7ce659c",
  "GrantId": "0e6692b588b8816d6ea097e90c45271f8feb57a1a865f5f21b1f05e9c117c104",
  "Name": "ops-us-west-2-github-runner-dev-kms-spot-grant",
  "CreationDate": "2021-02-13T08:12:06-08:00",
  "GranteePrincipal": "arn:aws:iam::348180535083:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot",
  "IssuingAccount": "arn:aws:iam::348180535083:root",
  "Operations": [
    "Decrypt",
    "Encrypt",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "ReEncryptFrom",
    "ReEncryptTo",
    "CreateGrant",
    "DescribeKey"
  ]
}
```
