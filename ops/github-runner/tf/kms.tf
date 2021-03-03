locals {
  kms_key_id = var.kms_key_id == null && var.encrypt_secrets ? aws_kms_key.default[0].key_id : var.kms_key_id
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "default" {
  count               = var.manage_kms_key && var.encrypt_secrets ? 1 : 0
  is_enabled          = true
  enable_key_rotation = true
  tags                = local.tags

  policy = templatefile("${path.module}/policies/default-cmk-kms-policy.json", {
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}
resource "aws_kms_alias" "default" {
  count         = var.manage_kms_key && var.encrypt_secrets ? 1 : 0
  name          = "alias/github-action-runners/${var.environment}"
  target_key_id = aws_kms_key.default[0].key_id
}
resource "aws_kms_key" "sqs_kms" {
  description         = "key for runner sqs encryption"
  is_enabled          = true
  enable_key_rotation = true
  tags                = local.tags

  policy = templatefile("${path.module}/policies/sqs-cmk-kms-policy.json", {
    env            = var.environment
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}
resource "aws_kms_alias" "sqs_kms" {
  name          = "alias/github-action-runners/${var.environment}/sqs"
  target_key_id = aws_kms_key.sqs_kms.key_id
}
