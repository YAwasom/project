
#This is to create the IAM Policies for the ECS tefds, these policies are specific to efd and may need adjustment for other applications (How do we generalize this?)
#ECS Role, allows ECS services to assume STS roles
data "aws_iam_policy_document" "efdecsrole"{
statement {
    effect          = "Allow"
    actions         = ["sts:AssumeRole"]
    principals  {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs.amazonaws.com","ecs-tasks.amazonaws.com"]

    }
  }
  
}
#STS Policy
data "aws_iam_policy_document" "efdecsrolepolicy" {

  statement {
    effect = "Allow"
    actions = [
                "ssmmessages:OpenDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:CreateControlChannel",
                "ssm:UpdateInstanceInformation",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateAssociationStatus",
                "ssm:PutInventory",
                "ssm:PutConfigurePackageResult",
                "ssm:PutComplianceItems",
                "ssm:ListInstanceAssociations",
                "ssm:ListAssociations",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:GetManifest",
                "ssm:GetDocument",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:DescribeParameters",
                "ssm:DescribeDocument",
                "ssm:DescribeAssociation",
                "elasticloadbalancing:*",
                "ecs:*",
                "ecr:*",
                "ec2messages:SendReply",
                "ec2messages:GetMessages",
                "ec2messages:GetEndpoint",
                "ec2messages:FailMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:AcknowledgeMessage",
                "application-autoscaling:*",
                "sts:*",
                "kms:Decrypt",
                "logs:GetLogEvents",
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutRetentionPolicy",
                "logs:CreateLogGroup",
                "rds:DescribeDBClusters"

    ]

    resources = [
        "*"
    ]
  }


}


#Create the IAM Role based on above policy
resource "aws_iam_role" "efdecsrole" {
  name                = "wb-cmd-efd-ecs-${var.app}-${var.efd_env}-${var.region}-efdECSRole"
  assume_role_policy  = data.aws_iam_policy_document.efdecsrole.json
}

#Create the IAM/ECS profile based on the policy
resource "aws_iam_instance_profile" "wb-cmd-efd-ecs-efd-efdECSInstanceProfile" {
  name      = "wb-cmd-efd-ecs--${var.app}-${var.efd_env}-${var.region}-efdECSInstanceProfile"
  role      = aws_iam_role.efdecsrole.name
}

#Assign the policy to the role
resource "aws_iam_role_policy" "efdecsrolepolicy" {
  name      = "efd-ecs"
  role      = aws_iam_role.efdecsrole.id
  policy     = data.aws_iam_policy_document.efdecsrolepolicy.json
}

#Assign the policy to the role
resource "aws_iam_role_policy_attachment" "cloudwatchagentserverpolicy" {
  role                = aws_iam_role.efdecsrole.id
  policy_arn          = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}