resource "aws_flow_log" "efd_flowlogs" {
    
    iam_role_arn    = aws_iam_role.efd_flowlogs.arn
    log_destination = aws_cloudwatch_log_group.efd_flowlogs.arn
    traffic_type    = "ALL"
    vpc_id          = aws_vpc.main.id

}

resource "aws_cloudwatch_log_group" "efd_flowlogs" {
  name = "efd-${var.efd_env}-flow-logs"
}

resource "aws_iam_role" "efd_flowlogs" {
    name = "efd-${var.efd_env}-efd-flow-iamrole"
    assume_role_policy = data.aws_iam_policy_document.efd_flow_assumerolepolicy.json
}


data "aws_iam_policy_document" "efd_flow_assumerolepolicy" {
    statement {
        effect          = "Allow"
        actions         = ["sts:AssumeRole"]
        principals  {
            type        = "Service"
            identifiers = ["vpc-flow-logs.amazonaws.com"]

        }
  }
}
  
data "aws_iam_policy_document" "efd_flow_rolepolicy" {

  statement {
    effect = "Allow"
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"

    ]

    resources = [
        "*"
    ]
  }


}

resource "aws_iam_role_policy" "efd_flow_iampolicy" {
    name = "efd-${var.efd_env}-efd-flow-policy"
    role = aws_iam_role.efd_flowlogs.id
    policy = data.aws_iam_policy_document.efd_flow_rolepolicy.json
}