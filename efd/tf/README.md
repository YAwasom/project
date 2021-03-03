# efd Mongo Atlas Terraform

[private endpoint creation](../../tf-modules/data-stores/mongo_atlas/README.md)


# EFD Automation Scripts in Terraform

This folder contains terraform based scripts for building the EFD environment.

Terraform is setup to use a split backend with the back end stored in an S3 bucket in the app associated aws account.


# backend-setup
Each back end has a setup folder that contains the TF scripts to build the backend as well as the resulting state file.  This is executed only once to initialize a blank backend.
        The following values should be customized:
          tfregion  = 
          tflocks   = 
          tfbucket  = 

TF will assume your currently configured AWS profile credentials to create these objects.  Login to the account using awsp first.

# Current Version 0.132
Code is based on TF .132.
# Usage

# Init
You need to "initialize" terraform first.  This specifies the backend to use as well as downloads any necessary modules for TF to use.

terraform init -backend-config=backend.conf

# Plan
You should always review the execution plan first, terraform can be very destructive if you have made significant changs to configuration (deletion and recreation of objects), the plan allows you to review changes without risk of execution.

terraform plan -var-file=../../../../../secrets.tfvars .

# Execute / Apply
terraform apply -var-file=../../../../../secrets.tfvars .

# Secrets
Secrets should be stored outside of the GIT repository, these populate SSM values.  You will need to make your own secrets file using the SSM values prior to running.

# tfapply.sh

./tfapply.sh

This script executes the above commands for the environment (dev,stage) etc that you are in.

# Credentials
Terraform will look for a profile that matches the  provider set in the code.  Refer to main.tf
# Command Arguments
terraform - TF executable should be in your path

init/apply/plan - command you would like to run (see previous)

-var-file - You can pass in variables stored in a file, in this example I have some secrets that are stored outside of the repository.  Terraform will also automatically load any files that end with .auto.tfvars

. - Path to TF files.  it is recommended executing from the git repo you are working with, TF creates a temporary folder (.terraform) that caches modules and a few settings which can cause you problems if you are executing multiple projects from the same folder.

# Reading the code/Entrypoint
Terraform does not have a specific entrypoint, this can make the code hard to read.  The order of execution is controlled by the respective providers for terraform, it is fully (most of the time) aware of what dependencies each resource has and will build things in the appropriate order.  Occasionally a depends_on clause can/will be used to ensure this but it should be avoided unless a specific problem is encountered.


# Regional Setup
Stage environment contains east and west folders for region specific code.  Setup creates a global RDS cluster with write forwarding using us-west-2 and us-east-2.


# Additional Setup
Permissions need to be granted in ECR registry (OPS account) for execution account to be able to read the docker images.

ecs.json needs correct ECS role recorded in file.