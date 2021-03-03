module "mongodbatlas_cluster" {
  source      = "../../../../../tf-modules/data-stores/mongo_atlas/mongodbatlas_cluster"
  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  project_id  = var.project_id
}


