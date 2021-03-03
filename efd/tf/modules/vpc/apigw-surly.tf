
resource "aws_api_gateway_vpc_link" "alb-surly" {
  name        = "${var.efd_env}_vpc_alb_surly_link"
  target_arns = [aws_lb.efdsurlylb.arn]
}

resource "aws_api_gateway_rest_api" "efd_surly_api" {
  name        = "efd_${var.efd_env}_api_surly"
  description = ""

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "efd_surly_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_surly_api.id
  parent_id   = aws_api_gateway_rest_api.efd_surly_api.root_resource_id
  path_part   = "static-url-ws"
}

module "efd_surly_api_root" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_surly_api.id
  resource_id = aws_api_gateway_resource.efd_surly_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_surly_services_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_surly_api.id
  parent_id   = aws_api_gateway_resource.efd_surly_resource.id
  path_part   = "services"
}

module "efd_surly_api_rest" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_surly_api.id
  resource_id = aws_api_gateway_resource.efd_surly_services_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_surly_staticurl_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_surly_api.id
  parent_id   = aws_api_gateway_resource.efd_surly_services_resource.id
  path_part   = "staticURLservice"
}

module "efd_surly_staticurl_rest" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_surly_api.id
  resource_id = aws_api_gateway_resource.efd_surly_staticurl_resource.id
  method      = "OPTIONS"

}

module "efd_surly_api_staticurl_post" {
  source = "../api-post"

  api_id      = aws_api_gateway_rest_api.efd_surly_api.id
  resource_id = aws_api_gateway_resource.efd_surly_staticurl_resource.id
  method      = "POST"
  endpoint    = "/static-url-ws/services/staticURLService"
  alb_arn     = aws_lb.efdsurlylb.arn
  efd_env     = var.efd_env
  alb_uri     = aws_lb.efdsurlylb.dns_name
  vpc_gateway = aws_api_gateway_vpc_link.alb-surly.id

}


resource "aws_api_gateway_resource" "efd_surly_token_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_surly_api.id
  parent_id   = aws_api_gateway_resource.efd_surly_resource.id
  path_part   = "{token}"
}

module "efd_surly_api_token" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_surly_api.id
  resource_id = aws_api_gateway_resource.efd_surly_token_resource.id
  method      = "OPTIONS"

}


module "efd_surly_api_token_get" {
  source = "../api-get"

  api_id      = aws_api_gateway_rest_api.efd_surly_api.id
  resource_id = aws_api_gateway_resource.efd_surly_token_resource.id
  method      = "GET"
  alb_arn     = aws_lb.efdsurlylb.arn
  efd_env     = var.efd_env
  alb_uri     = aws_lb.efdsurlylb.dns_name
  endpoint    = "/static-url-ws/{token}"
  vpc_gateway = aws_api_gateway_vpc_link.alb-surly.id

}


resource "aws_api_gateway_domain_name" "efd_surly_api_domainname" {
  regional_certificate_arn = "arn:aws:acm:us-west-2:656419642964:certificate/2c4c4f51-a0e0-4305-a528-8997d92c08a2"
  domain_name              = "surly-dev.malt.warnerbros.com"
  security_policy          = "TLS_1_2"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_base_path_mapping" "efd_surly_api_namemapping" {
  api_id      = aws_api_gateway_rest_api.efd_surly_api.id
  stage_name  = aws_api_gateway_deployment.efd_surly_api_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.efd_surly_api_domainname.domain_name
}

resource "aws_api_gateway_method" "efd_surly_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.efd_surly_api.id
  resource_id   = aws_api_gateway_rest_api.efd_surly_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "efd_surly_api_integration" {
  rest_api_id = aws_api_gateway_rest_api.efd_surly_api.id
  resource_id = aws_api_gateway_rest_api.efd_surly_api.root_resource_id
  http_method = aws_api_gateway_method.efd_surly_api_method.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "efd_surly_api_deployment" {
  depends_on = [aws_api_gateway_integration.efd_surly_api_integration]

  rest_api_id = aws_api_gateway_rest_api.efd_surly_api.id
  stage_name  = "dev"


  lifecycle {
    create_before_destroy = true
  }
}
