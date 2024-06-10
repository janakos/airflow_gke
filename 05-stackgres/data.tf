data "google_project" "project" {}

data "google_client_config" "default" {}

data "google_container_cluster" "airflow" {
  name     = var.cluster
  location = var.region
  project  = var.project_id
}
