resource "aws_ssm_parameter" "cloudwatch" {
  name  = "/${var.efd_env}/ops.cloudwatch"
  type  = "String"
  tier  = "Advanced"
  value = templatefile("${path.module}/${var.cloudwatch_file}", {efdenv = var.efd_env})
  overwrite = true

}