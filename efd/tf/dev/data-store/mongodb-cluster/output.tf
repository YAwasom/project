output "cluster_id" {
  value = "${module.mongodbatlas_cluster.cluster_id}"
}

output "mongo_uri" {
  value = "${module.mongodbatlas_cluster.mongo_uri}"
}

output "mongo_uri_with_options" {
  value = "${module.mongodbatlas_cluster.mongo_uri_with_options}"
}

output "srv_address" {
  value = "${module.mongodbatlas_cluster.srv_address}"
}