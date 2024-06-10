terraform {

  backend "gcs" {
    bucket = "iguana-tf-state-stage"
    prefix = "iguana/airflow/terraform/gcp-us-central1/iguana-staging/airflow-on-gke/08-airflow-postgres"
  }

  required_version = "~> 1.7.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubectl" {
  host             = "https://${data.google_container_cluster.airflow.endpoint}"
  token            = data.google_client_config.default.access_token
  load_config_file = false
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.airflow.master_auth[0].cluster_ca_certificate
  )
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.airflow.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.airflow.master_auth[0].cluster_ca_certificate
  )
}