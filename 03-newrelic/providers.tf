terraform {

  backend "gcs" {
    bucket = "iguana-tf-state-stage"
    prefix = "iguana/airflow/terraform/gcp-us-central1/iguana-staging/airflow-on-gke/03-newrelic"
  }

  required_version = "~> 1.7.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.airflow.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.airflow.master_auth[0].cluster_ca_certificate
    )
  }
}

provider "newrelic" {
  account_id = 3032839
  api_key    = data.google_secret_manager_secret_version.new_relic_api_key.secret_data
  region     = "US"
}