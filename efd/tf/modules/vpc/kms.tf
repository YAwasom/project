resource "aws_kms_alias" "ebs" {
  name          = "alias/efd_kms_ebs_${var.efd_env}"
  target_key_id = aws_kms_key.efd_ebs_kms.key_id
}

resource "aws_kms_key" "efd_ebs_kms" {
    description         = "Key for SSM Parameter Encryption"
    enable_key_rotation = true
    tags = {
        Name = "efd_kms_ebs_${var.efd_env}"
    }
}

resource "aws_kms_key" "efd_params" {
    description         = "Key for SSM Parameter Encryption"
    enable_key_rotation = true
    tags = {
        Name = "efd_kms_params_${var.efd_env}"
    }   
}

resource "aws_kms_alias" "ask_params" {
  name          = "alias/efd_kms_params_${var.efd_env}"
  target_key_id = aws_kms_key.efd_params.key_id
}

resource "aws_kms_grant" "ebsrole" {
  name                = "ebs"
  key_id              = aws_kms_key.efd_ebs_kms.id
  grantee_principal   =  "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations          = ["CreateGrant", "Decrypt", "DescribeKey", "Encrypt", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "ReEncryptFrom", "ReEncryptTo", "RetireGrant"]
}