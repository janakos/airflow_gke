data "google_project" "project" {}

data "google_client_config" "default" {}

data "google_container_cluster" "airflow" {
  name     = var.cluster
  location = var.region
  project  = var.project_id
}

data "kubernetes_secret" "postgres" {
  for_each = toset(local.namespaces)

  metadata {
    name      = local.postgres_name
    namespace = each.value
  }
}

data "kubernetes_secret" "airflow-key" {
  for_each = toset(local.namespaces)

  metadata {
    name      = "airflow-secret-keys"
    namespace = each.value
  }
}

data "google_secret_manager_secret_version" "gh_service_account_password" {
  secret = "gh_service_account_airflow_password"
}

