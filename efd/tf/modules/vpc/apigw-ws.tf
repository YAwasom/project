
resource "aws_api_gateway_vpc_link" "alb-ws" {
  name        = "${var.efd_env}_vpc_alb_ws_link"
  target_arns = [aws_lb.efdwslb.arn]
}

resource "aws_api_gateway_rest_api" "efd_ws_api" {
  name        = "efd_${var.efd_env}_api_ws"
  description = ""

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "efd_ws_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_rest_api.efd_ws_api.root_resource_id
  path_part   = "mars-efd-ws"
}

module "efd_ws_api_root" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_ws_rest_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_resource.id
  path_part   = "rest"
}

module "efd_ws_api_rest" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_rest_resource.id
  method      = "OPTIONS"

}


resource "aws_api_gateway_resource" "efd_ws_portal_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_rest_resource.id
  path_part   = "PortalWebservice"
}

module "efd_ws_api_portal" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_portal_resource.id
  method      = "OPTIONS"

}


resource "aws_api_gateway_resource" "efd_ws_hash_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_portal_resource.id
  path_part   = "hashRest"
}

module "efd_ws_api_hash" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_hash_resource.id
  method      = "OPTIONS"

}


module "efd_ws_api_hash_post" {
  source = "../api-post"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_hash_resource.id
  method      = "POST"
  endpoint    = "/mars-efd-ws/rest/PortalWebservice/hashRest"
  alb_arn     = aws_lb.efdwslb.arn
  efd_env     = var.efd_env
  alb_uri     = aws_lb.efdwslb.dns_name
  vpc_gateway = aws_api_gateway_vpc_link.alb-ws.id

}

resource "aws_api_gateway_resource" "efd_ws_successnotification_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_portal_resource.id
  path_part   = "successNotification"
}

module "efd_ws_successnotification" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_successnotification_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_ws_fn1_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_successnotification_resource.id
  path_part   = "fileName"
}

module "efd_ws_api_fn1" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_fn1_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_ws_fn2_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_fn1_resource.id
  path_part   = "{fileName}"
}

module "efd_ws_api_fn2" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_fn2_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_ws_portalname_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_fn2_resource.id
  path_part   = "portalName"
}

module "efd_ws_api_portalname" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_portalname_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_ws_portalname2_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_portalname_resource.id
  path_part   = "{portalName}"
}

module "efd_ws_api_portalname2" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_portalname2_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_ws_requestid_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_portalname2_resource.id
  path_part   = "requestId"
}

module "efd_ws_api_requestid" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_requestid_resource.id
  method      = "OPTIONS"

}

resource "aws_api_gateway_resource" "efd_ws_requestid2_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_requestid_resource.id
  path_part   = "{requestId}"
}

module "efd_ws_api_requestid2" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_requestid2_resource.id
  method      = "OPTIONS"

}


module "efd_ws_api_requestid2_get" {
  source = "../api-get"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_requestid2_resource.id
  method      = "GET"
  alb_arn     = aws_lb.efdwslb.arn
  efd_env     = var.efd_env
  alb_uri     = aws_lb.efdwslb.dns_name
  endpoint    = "/mars-efd-ws/services/rest/PortalWebservice/successNotification/fileName/{fileName}/portalName/{portalName}/requestId/{requestId}"
  vpc_gateway = aws_api_gateway_vpc_link.alb-ws.id

}




resource "aws_api_gateway_resource" "efd_ws_portalrest_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_rest_resource.id
  path_part   = "PortalWebserviceRest"
}

module "efd_ws_api_portalrest" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_portalrest_resource.id
  method      = "OPTIONS"

}


resource "aws_api_gateway_resource" "efd_ws_hashrest_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_portalrest_resource.id
  path_part   = "hashRest"
}

module "efd_ws_api_hashrest" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_hashrest_resource.id
  method      = "OPTIONS"

}


module "efd_ws_api_hashrest_post" {
  source = "../api-post"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_hashrest_resource.id
  method      = "POST"
  alb_arn     = aws_lb.efdwslb.arn
  endpoint    = "/mars-efd-ws/rest/PortalWebservice/hashRest"
  efd_env     = var.efd_env
  alb_uri     = aws_lb.efdwslb.dns_name
  vpc_gateway = aws_api_gateway_vpc_link.alb-ws.id

}


resource "aws_api_gateway_resource" "efd_ws_services_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_resource.id
  path_part   = "services"
}

module "efd_ws_api_services" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_services_resource.id
  method      = "OPTIONS"

}





resource "aws_api_gateway_resource" "efd_ws_portalservice_resource" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  parent_id   = aws_api_gateway_resource.efd_ws_services_resource.id
  path_part   = "portalService"
}

module "efd_ws_api_portalservice" {
  source = "../api-options"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_portalservice_resource.id
  method      = "OPTIONS"

}


module "efd_ws_api_portalservice_post" {
  source = "../api-post"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_portalservice_resource.id
  method      = "POST"
  endpoint    = "/mars-efd-ws/services/portalService"
  alb_arn     = aws_lb.efdwslb.arn
  efd_env     = var.efd_env
  alb_uri     = aws_lb.efdwslb.dns_name
  vpc_gateway = aws_api_gateway_vpc_link.alb-ws.id

}

module "efd_ws_api_portalservice_get" {
  source = "../api-get"

  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_resource.efd_ws_portalservice_resource.id
  method      = "GET"
  alb_arn     = aws_lb.efdwslb.arn
  efd_env     = var.efd_env
  alb_uri     = aws_lb.efdwslb.dns_name
  endpoint    = "/mars-efd-ws/services/portalService"
  vpc_gateway = aws_api_gateway_vpc_link.alb-ws.id

}

resource "aws_api_gateway_domain_name" "efd_ws_api_domainname" {
  regional_certificate_arn = "arn:aws:acm:us-west-2:656419642964:certificate/2c4c4f51-a0e0-4305-a528-8997d92c08a2"
  domain_name              = "efd-dev.malt.warnerbros.com"
  security_policy          = "TLS_1_2"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "efd_ws_api_namemapping" {
  api_id      = aws_api_gateway_rest_api.efd_ws_api.id
  stage_name  = aws_api_gateway_deployment.efd_ws_api_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.efd_ws_api_domainname.domain_name
}


resource "aws_api_gateway_method" "efd_ws_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id   = aws_api_gateway_rest_api.efd_ws_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "efd_ws_api_integration" {
  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  resource_id = aws_api_gateway_rest_api.efd_ws_api.root_resource_id
  http_method = aws_api_gateway_method.efd_ws_api_method.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "efd_ws_api_deployment" {
  depends_on = [aws_api_gateway_integration.efd_ws_api_integration]

  rest_api_id = aws_api_gateway_rest_api.efd_ws_api.id
  stage_name  = "dev"


  lifecycle {
    create_before_destroy = true
  }
}
