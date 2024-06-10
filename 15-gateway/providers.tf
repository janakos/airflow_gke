terraform {

  backend "gcs" {
    bucket = "iguana-tf-state-stage"
    prefix = "iguana/airflow/terraform/gcp-us-central1/iguana-staging/airflow-on-gke/15-gateway"
  }

  required_version = "~> 1.7.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
  }
}

data "google_client_config" "default" {}

data "google_container_cluster" "airflow-stage" {
  name     = "airflow-stage"
  location = var.region
  project  = var.project_id
}

# following example here https://github.com/hashicorp/terraform-provider-kubernetes/blob/c746a844fd511107adfd92e6cf336eb4b1fce963/_examples/gke/main.tf#L39C1-L45C2
provider "kubernetes" {
  host  = "https://${data.google_container_cluster.airflow-stage.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.airflow-stage.master_auth[0].cluster_ca_certificate,
  )
}