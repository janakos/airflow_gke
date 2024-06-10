data "google_project" "project" {}

data "google_client_config" "default" {}

data "google_container_cluster" "airflow" {
  name     = var.cluster
  location = var.region
  project  = var.project_id
}

data "google_secret_manager_secret_version" "new_relic_license_key" {
  secret = "new_relic_license_key"
}

data "google_secret_manager_secret_version" "new_relic_api_key" {
  secret = "new_relic_api_key"
}
