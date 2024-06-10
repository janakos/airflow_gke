resource "google_container_cluster" "airflow" {
  name                = var.cluster
  location            = var.region
  project             = var.project_id
  deletion_protection = true

  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  addons_config {
    dns_cache_config {
      enabled = true
    }
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
}

resource "google_container_node_pool" "airflow-pool" {
  name     = "airflow-pool"
  location = var.region
  cluster  = google_container_cluster.airflow.name
  project  = var.project_id

  node_count = 2

  node_config {
    machine_type = "n1-standard-64"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = data.google_service_account.airflow_service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_storage_bucket" "dag_bucket" {
  name     = local.dag_bucket
  location = var.region

  public_access_prevention = "enforced"
}
