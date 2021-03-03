data "aws_caller_identity" "current" {}
resource "aws_kms_key" "github_runner_kms" {
  description         = "key for runner encryption"
  is_enabled          = true
  enable_key_rotation = true
  tags = {
    Name = "${var.environment}-ops-kms-github-runner"
  }

  policy = templatefile("${path.module}/policies/runner-cmk-kms-policy.json", {
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}
resource "aws_kms_alias" "github_runner_kms" {
  name          = "alias/ops/github/action-runners"
  target_key_id = aws_kms_key.github_runner_kms.key_id
}
