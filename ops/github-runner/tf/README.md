# Ops aws github runner

Original code: <https://github.com/philips-labs/terraform-aws-github-runner>
Original docs: <https://github.com/philips-labs/terraform-aws-github-runner/blob/develop/README.md>

## Added features

- KMS CMK encryption for SQS, CloudWatch Logs
- Runners on Amazon Linux 2 Gold AMIs with Logging
- SSM Parameter Store for github app secrets
- Resource Renaming
- CSO Baseline Compliance

## Access

The github runners are enabled at the MALT org level. We selectively enable them for each repo that wants to use them.

Contact MSC-MALT OPS

`cmd-ops@warnerbros.com`

`#pit-dev-ops`

## Github Runners only for private repositories

*Don't use runners on public repositories!*

Forks of your public repository can potentially run dangerous code on your self-hosted runner machine by creating a pull request that executes the code in a workflow.

<https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners#self-hosted-runner-security-with-public-repositories>

## Terraform Deploy

```bash
~/Code/wm/ops/infrastructure/ops/github-runner/tf/dev [ops-us-west-2]:
🌨  ./tfapply.sh
```

## Lambda Deploy

- [Root Makefile](./Makefile)
- Builds all lambdas using their respective Makefiles
- [Lambda Webhook Makefile](./modules/webhook/lambdas/webhook/Makefile)

```bash
~/Code/wm/ops/infrastructure/ops/github-runner/tf/ [ops-us-west-2]:
🌨  make build && make dist
```

## Lambda S3 Object Versions

[aws_lambda_function doesn't use new aws_s3_bucket_object.version](https://github.com/hashicorp/terraform/issues/8829)

[Where lambda s3 object version key configs are](dev/main.tf)

`make dist` will print latest object version. For now copy the version keys into the config, commit the changes, and then deploy with `./tfapply.sh`

```bash
runners_lambda_s3_object_version = "CJD5i.6Qh94fnTb8ReHpymLgdZis9bOD"
syncer_lambda_s3_object_version = "d1ouHbAfyIBTul9ylwnMR56vNOVcpmFy"
webhook_lambda_s3_object_version = "PEM9Y1T9EEvaFa9KIKQK8m04zX56xaKL"
```

## Logs

[awslogs cli](https://github.com/jorgebastida/awslogs)

```bash
# Install
brew install awslogs

# List Groups
awslogs groups

# List Streams
awslogs streams /aws/lambda/dev-scale-down
awslogs streams /aws/lambda/dev-scale-up
awslogs streams /aws/lambda/dev-syncer
awslogs streams /aws/lambda/dev-webhook
awslogs streams /ops/github/runner/dev

# Generated in the 2hrs ago
awslogs get /aws/lambda/dev-scale-down ALL --start='2h ago' --ingestion-time
awslogs get /aws/lambda/dev-scale-up ALL --start='2h ago' --ingestion-time
awslogs get /aws/lambda/dev-syncer ALL --start='2h ago' --ingestion-time
awslogs get /aws/lambda/dev-webhook ALL --start='2h ago' --ingestion-time
awslogs get /ops/github/runner/dev ALL --start='2h ago' --ingestion-time

# Generated in the 2hrs ago
awslogs get /aws/lambda/dev-scale-down ALL --start='2min ago'
awslogs get /aws/lambda/dev-scale-up ALL --start='2min ago'
awslogs get /aws/lambda/dev-syncer ALL --start='2min ago'
awslogs get /aws/lambda/dev-webhook ALL --start='2min ago'
awslogs get /ops/github/runner/dev ALL --start='2min ago'
```

## Github App

[MALT Github Apps Settings](https://github.com/organizations/wm-msc-malt/settings/apps)
[MALT Github Runner App Settings](https://github.com/organizations/wm-msc-malt/settings/apps/malt-ops-aws-github-runner)

SSM Parameter Store Paths

```terraform
data "aws_ssm_parameter" "github_app_key_base64" {
  name = "/ops/github/runner/${var.environment}/private-key"
}

data "aws_ssm_parameter" "github_app_client_id" {
  name = "/ops/github/runner/${var.environment}/client-id"
}

data "aws_ssm_parameter" "github_app_client_secret" {
  name = "/ops/github/runner/${var.environment}/client-secret"
}
```

## Initial Github App Setup Debug

GitHub workflows fail immediately if there is `no action runner available for your builds`. Since this module supports scaling down to zero, builds will fail in case there is no active runner available.

We recommend to create an offline runner with matching labels to the configuration. `Create this runner manually by following the GitHub instructions for adding a new runner on your local machine`.

If you stop the process `after` the step of `running the config.sh script the runner will remain offline`. This offline runner ensures that builds will not fail immediately and stay queued until there is an EC2 runner to pick it up.

Follow the docs here:

<https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners#adding-a-self-hosted-runner-to-a-repository>
<https://docs.github.com/en/actions/hosting-your-own-runners/monitoring-and-troubleshooting-self-hosted-runners>

## Testing

[Github Runner Testing Repo](https://github.com/wm-msc-malt/github-runner-testing)

## Application Flow Overview

The moment a GitHub action workflow requiring a `self-hosted` runner is triggered, GitHub will try to find a runner which can execute the workload. This module reacts to GitHub's [`check_run` event](https://docs.github.com/en/free-pro-team@latest/developers/webhooks-and-events/webhook-events-and-payloads#check_run) for the triggered workflow and creates a new runner if necessary.

For receiving the `check_run` event, a GitHub App needs to be created with a webhook to which the event will be published. Installing the GitHub App in a specific repository or all repositories ensures the `check_run` event will be sent to the webhook.

In AWS a [HTTP API gateway](https://docs.aws.amazon.com/apigateway/index.html) endpoint is created that is able to receive the GitHub webhook events via HTTP post. The gateway triggers the webhook lambda which will verify the signature of the event. This check guarantees the event is sent by the GitHub App. The lambda only handles `check_run` events with status `created`. The accepted events are posted on a SQS queue. Messages on this queue will be delayed for a configurable amount of seconds (default 30 seconds) to give the available runners time to pick up this build.

The "scale up runner" lambda is listening to the SQS queue and picks up events. The lambda runs various checks to decide whether a new EC2 spot instance needs to be created. For example, the instance is not created if the build is already started by an existing runner, or the maximum number of runners is reached.

The Lambda first requests a registration token from GitHub which is needed later by the runner to register itself. This avoids that the EC2 instance, which later in the process will install the agent, needs administration permissions to register the runner. Next the EC2 spot instance is created via the launch template. The launch template defines the specifications of the required instance and contains a [`user_data`](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) script. This script will install the required software and configure it. The registration token for the action runner is stored in the parameter store (SSM) from which the user data script will fetch it and delete it once it has been retrieved. Once the user data script is finished the action runner should be online and the workflow will start in seconds.

Scaling down the runners is at the moment brute-forced, every configurable amount of minutes a lambda will check every runner (instance) if it is busy. In case the runner is not busy it will be removed from GitHub and the instance terminated in AWS. At the moment there seems no other option to scale down more smoothly.

Downloading the GitHub Action Runner distribution can be occasionally slow (more than 10 minutes). Therefore a lambda is introduced that synchronizes the action runner binary from GitHub to an S3 bucket. The EC2 instance will fetch the distribution from the S3 bucket instead of the internet.

Secrets and private keys which are passed to the lambdas as environment variables are encrypted by default with KMS CMK that are managed by the module.
