terraform {
  backend "gcs" {
    bucket = "iguana-tf-state-stage"
    prefix = "iguana/airflow/terraform/gcp-us-central1/iguana-staging/airflow-on-gke/00-cluster"
  }

  required_version = "~> 1.7.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

