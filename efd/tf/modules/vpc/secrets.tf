
resource "aws_ssm_parameter" "surly_jdbc_url" {
  name      = "/${var.efd_env}/surly.jdbc.url"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["surly_jdbc_url"]#var.surly_jdbc_url 
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}

resource "aws_ssm_parameter" "surly_jdbc_password" {
  name      = "/${var.efd_env}/surly.jdbc.password"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["surly_jdbc_password"]#var.surly_jdbc_password
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}


resource "aws_ssm_parameter" "surly_jdbc_username" {
  name      = "/${var.efd_env}/surly.jdbc.username"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["surly_jdbc_username"]#var.surly_jdbc_username
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}

resource "aws_ssm_parameter" "ws_jdbc_url" {
  name      = "/${var.efd_env}/ws.jdbc.url"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["ws_jdbc_url"]#var.ws_jdbc_url 
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}

resource "aws_ssm_parameter" "ws_jdbc_password" {
  name      = "/${var.efd_env}/ws.jdbc.password"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["ws_jdbc_password"]#var.ws_jdbc_password
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}


resource "aws_ssm_parameter" "ws_jdbc_username" {
  name      = "/${var.efd_env}/ws.jdbc.username"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["ws_jdbc_username"]#var.ws_jdbc_username
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}

resource "aws_ssm_parameter" "ws_jdbc_collectionname" {
  name      = "/${var.efd_env}/ws.jdbc.collectionname"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["ws_jdbc_collectionname"]# var.ws_jdbc_collectionname
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}


resource "aws_ssm_parameter" "blitline_jdbc_password" {
  name      = "/${var.efd_env}/blitline.jdbc.password"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["blitline_jdbc_password"]#var.ws_jdbc_password
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}


resource "aws_ssm_parameter" "blitline_jdbc_username" {
  name      = "/${var.efd_env}/blitline.jdbc.username"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["blitline_jdbc_username"]#var.ws_jdbc_username
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}

resource "aws_ssm_parameter" "blitline_jdbc_url" {
  name      = "/${var.efd_env}/blitline.jdbc.url"
  type      = "SecureString"
  value     = yamldecode(data.aws_ssm_parameter.secrets.value)["blitline_jdbc_url"] #var.ws_jdbc_collectionname
  overwrite = true
  key_id    = aws_kms_key.efd_params.arn

}