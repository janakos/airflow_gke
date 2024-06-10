provider "google" {
  project = var.project_id
  region  = var.region
}

provider "helm" {
  kubernetes {
    host  = "https://${google_container_cluster.airflow.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.airflow.master_auth[0].cluster_ca_certificate
    )
  }
}
