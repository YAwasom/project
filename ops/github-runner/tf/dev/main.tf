data "aws_ssm_parameter" "github_app_key_base64" {
  name = "/ops/github/runner/${var.environment}/private-key"
}

data "aws_ssm_parameter" "github_app_client_id" {
  name = "/ops/github/runner/${var.environment}/client-id"
}

data "aws_ssm_parameter" "github_app_client_secret" {
  name = "/ops/github/runner/${var.environment}/client-secret"
}

resource "random_password" "random" {
  length = 28
}
data "aws_kms_key" "github_runner_kms" {
  key_id = aws_kms_key.github_runner_kms.key_id
}

module "runners" {
  source = "../"
  # wb-cmd-ops-vpc
  vpc_id = var.vpc_id
  # wb-cmd-ops-vpc-private-subnet-*
  subnet_ids = [var.private_subnet_id_a, var.private_subnet_id_b, var.private_subnet_id_c]

  aws_region  = var.region
  environment = var.environment

  tags = {
    Name = "ops-github-runner"
  }

  github_app = {
    key_base64     = base64encode(data.aws_ssm_parameter.github_app_key_base64.value)
    id             = var.github_app_id
    client_id      = data.aws_ssm_parameter.github_app_client_id.value
    client_secret  = data.aws_ssm_parameter.github_app_client_secret.value
    webhook_secret = random_password.random.result
  }

  # Enable runners for the org
  enable_organization_runners = true

  # Enable ssm access
  enable_ssm_on_runners = true

  # Encrypt secret variables for lambda's such as secrets and private keys
  encrypt_secrets = true

  # Use custom kms key
  manage_kms_key       = false
  kms_key_id           = data.aws_kms_key.github_runner_kms.id

  gold_ami_kms_key_id  = "a370c4f2-5a11-4a3e-a5fa-3a5bc7ce659c"
  gold_ami_kms_key_arn = "arn:aws:kms:us-west-2:${data.aws_caller_identity.current.account_id}:key/a370c4f2-5a11-4a3e-a5fa-3a5bc7ce659c"

  # Local lambdas
  # webhook_lambda_zip                = "../modules/webhook/lambdas/webhook/webhook.zip"
  # runner_binaries_syncer_lambda_zip = "../modules/runner-binaries-syncer/lambdas/runner-binaries-syncer/runner-binaries-syncer.zip"
  # runners_lambda_zip                = "../modules/runners/lambdas/runners/runners.zip"

  # Remote lambdas
  lambda_s3_bucket                 = "wb-cmd-ops-s3-dist"
  runners_lambda_s3_key            = "ops-github-runners/runners.zip"
  runners_lambda_s3_object_version = "CJD5i.6Qh94fnTb8ReHpymLgdZis9bOD"

  syncer_lambda_s3_key            = "ops-github-runners/runner-binaries-syncer.zip"
  syncer_lambda_s3_object_version = "d1ouHbAfyIBTul9ylwnMR56vNOVcpmFy"

  webhook_lambda_s3_key            = "ops-github-runners/webhook.zip"
  webhook_lambda_s3_object_version = "PEM9Y1T9EEvaFa9KIKQK8m04zX56xaKL"

  # Number of days you want to retain log events for the lambda log group
  logging_retention_in_days = 30

  # 60 second scale down timeout
  runners_scale_down_lambda_timeout = 60

  # 1 hour scale down check
  scale_down_schedule_expression = "cron(*/5 * * * ? *)"

  # 1 hour scale down check
  minimum_running_time_in_minutes = 60

  # Maximum number of runners that will be created
  runners_maximum_count = 2

  # Idle runners on from 4am-10pm PST Mon-Fri
  idle_config = [{
    cron      = "* * 4-22 * * 1-5"
    timeZone  = "America/Los_Angeles"
    idleCount = 1
  }]

  # Extra labels for the github runners 
  runner_extra_labels = "linux,amazon-linux-2,self-hosted"

  # Instance type for the action runner
  instance_type = "c5.xlarge"

  ##################################
  ## Amazon linux 2 configuration ##
  ##################################

  # ops account
  ami_owners = ["348180535083"]
  # 348180535083/gold-amz2-ec2-gp2-1613174410
  ami_filter = {
    name = ["gold-amz2-ec2-gp2-1613174410"]
  }

  userdata_template = "./templates/user-data.sh"

  # Set the block device name for Ubuntu root device
  block_device_mappings = {
    device_name = "/dev/sda1"
  }

  # Replaces the module default cloudwatch log config
  # https://docs.github.com/en/actions/hosting-your-own-runners/monitoring-and-troubleshooting-self-hosted-runners
  runner_log_files = [
    {
      "file_path" : "/var/log/user-data.log",
      "log_stream_name" : "{instance_id}/user_data",
      "log_group_name" : "ops/github/runner/${var.environment}",
      "prefix_log_group" : false
    },
    {
      "file_path" : "/home/ec2-user/actions-runner/_diag/Runner_**.log",
      "log_stream_name" : "{instance_id}/runner"
      "log_group_name" : "ops/github/runner/${var.environment}",
      "prefix_log_group" : false
    }
  ]
}
