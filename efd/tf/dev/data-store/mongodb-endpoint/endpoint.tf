module "endpoint" {
  source           = "../../../../../tf-modules/data-stores/mongo_atlas/mongodbatlas_endpoint"
  namespace        = var.namespace
  environment      = var.environment
  name             = var.name
  vpc_id           = var.vpc_id
  service_name     = var.service_name
  subnets_ids      = var.subnets_ids
  compute_sg       = var.compute_sg
  endpoint_sg_name = var.endpoint_sg_name
}
