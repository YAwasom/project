
resource "aws_api_gateway_method" "efd_ws_api_method" {
  rest_api_id   = var.api_id
  resource_id   = var.resource_id
  http_method   = var.method
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "efd_ws_api_integration" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.efd_ws_api_method.http_method
  type        = "MOCK"

  timeout_milliseconds = 29000

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/json" = <<EOF
    {"statusCode": 200}
EOF
  }
}

resource "aws_api_gateway_method_response" "efd_ws_api_response_200" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.efd_ws_api_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true

  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "efd_ws_api_intresp" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.efd_ws_api_method.http_method
  status_code = aws_api_gateway_method_response.efd_ws_api_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"

  }

  response_templates = {
    "application/json" = ""
  }

}
