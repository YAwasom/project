
resource "aws_api_gateway_method" "efd_ws_api_method" {
  rest_api_id   = var.api_id
  resource_id   = var.resource_id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.requestId"  = true
    "method.request.path.fileName"   = true
    "method.request.path.portalName" = true
  }

}

resource "aws_api_gateway_integration" "efd_ws_api_integration" {
  rest_api_id             = var.api_id
  resource_id             = var.resource_id
  http_method             = var.method
  type                    = "HTTP"
  integration_http_method = var.method
  uri                     = "http://${var.alb_uri}${var.endpoint}"
  timeout_milliseconds    = 29000

  # Transforms the incoming XML request to JSON
  connection_type = "VPC_LINK"
  connection_id   = var.vpc_gateway

  request_parameters = {
    "integration.request.header.requestId"  = "method.request.path.requestId"
    "integration.request.header.fileName"   = "method.request.path.fileName"
    "integration.request.header.portalName" = "method.request.path.portalName"
  }
}

resource "aws_api_gateway_method_response" "efd_ws_api_response_200" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "201"

  response_models = {
    "application/xml" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "efd_ws_api_intresp" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = var.method
  status_code = "201"

  depends_on = [
    aws_api_gateway_integration.efd_ws_api_integration
  ]

}
