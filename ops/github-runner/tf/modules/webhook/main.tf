locals {
  webhook_endpoint = "webhook"
  role_path        = var.role_path == null ? "/${var.environment}/" : var.role_path
  lambda_zip       = var.lambda_zip == null ? "${path.module}/lambdas/webhook/webhook.zip" : var.lambda_zip
}

resource "aws_apigatewayv2_api" "webhook" {
  name          = "${var.environment}-github-action-webhook"
  protocol_type = "HTTP"
  tags          = var.tags
}

resource "aws_apigatewayv2_route" "webhook" {
  api_id    = aws_apigatewayv2_api.webhook.id
  route_key = "POST /${local.webhook_endpoint}"
  target    = "integrations/${aws_apigatewayv2_integration.webhook.id}"
}

resource "aws_cloudwatch_log_group" "webhook_api" {
  name              = "/aws/apigateway/ops/github/runner/${var.environment}/"
  retention_in_days = 30
  tags              = var.tags
  kms_key_id        = "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/${var.encryption.kms_key_id}"
}

resource "aws_apigatewayv2_stage" "webhook" {
  lifecycle {
    ignore_changes = [
      // see bug https://github.com/terraform-providers/terraform-provider-aws/issues/12893
      default_route_settings,
      // not terraform managed
      deployment_id
    ]
  }

  default_route_settings {
    detailed_metrics_enabled = true
  }

  route_settings {
    route_key = "$default"
    detailed_metrics_enabled = true
    throttling_burst_limit = 1000
    throttling_rate_limit = 1000
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.webhook_api.arn
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "caller" : "$context.identity.caller", "user" : "$context.identity.user", "requestTime" : "$context.requestTime", "httpMethod" : "$context.httpMethod", "status" : "$context.status", "protocol" : "$context.protocol", "responseLength" : "$context.responseLength" })
  }

  api_id      = aws_apigatewayv2_api.webhook.id
  name        = "$default"
  auto_deploy = true
  tags        = var.tags
}

resource "aws_apigatewayv2_integration" "webhook" {
  lifecycle {
    ignore_changes = [
      // not terraform managed
      passthrough_behavior
    ]
  }

  api_id           = aws_apigatewayv2_api.webhook.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  description        = "GitHub App webhook for receiving build events."
  integration_method = "POST"
  integration_uri    = aws_lambda_function.webhook.invoke_arn
}

# Api gateway http apis don't support waf
#
# resource "aws_wafv2_web_acl_association" "webhook_waf" {
#   resource_arn = "arn:aws:apigateway:us-west-2::/apis/*/stages/*"
#   # arn:aws:apigateway:us-east-1::/restapis/*api-id*/stages/dev
#   #resource_arn = aws_apigatewayv2_stage.webhook.arn
#   web_acl_arn  = aws_wafv2_web_acl.webhook_waf.arn
# }

# resource "aws_wafv2_web_acl" "webhook_waf" {
#   name        = "${var.environment}-github-action-webhook-waf"
#   description = "compliant with cso guidelines specified in baseline for web application firewalls at one.warnermedia.com"
#   scope       = "REGIONAL"

#   default_action {
#     allow {}
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "${var.environment}-github-action-webhook-waf-metric"
#     sampled_requests_enabled   = true
#   }

#   rule {
#     name     = "RulesAWSManagedCommonRuleSet"
#     priority = 0

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesCommonRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "RulesAWSManagedSQLiRuleSet"
#     priority = 1

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesSQLiRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesSQLiRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "RulesAWSManagedAdminProtectionRuleSet"
#     priority = 2

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAdminProtectionRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesAdminProtectionRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "RulesAWSManagedKnownBadInputsRuleSet"
#     priority = 3

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesKnownBadInputsRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "RulesAWSManagedLinuxRuleSet"
#     priority = 4

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesLinuxRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesLinuxRuleSetMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "RulesAWSManagedAnonymousIpList"
#     priority = 5

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAnonymousIpList"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesAnonymousIpListMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWSManagedRulesAmazonIpReputationList"
#     priority = 6

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAmazonIpReputationList"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesAmazonIpReputationListMetric"
#       sampled_requests_enabled   = true
#     }
#   }

#   tags = {
#     Name = "${var.environment}-github-action-webhook-waf"
#   }
# }
