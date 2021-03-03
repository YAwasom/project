module "mongodbatlas_cluster" {
  source      = "../../../../../tf-modules/data-stores/mongo_atlas/mongodbatlas_cluster"
  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  project_id  = var.project_id
  # prod setup
  provider_instance_size_name = "${var.provider_instance_size_name}"
  provider_backup_enabled     = "${var.provider_backup_enabled}"
  disk_size_gb                = "${var.disk_size_gb}"
}
