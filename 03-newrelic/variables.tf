variable "project_id" {
  type        = string
  default     = "iguana-staging"
  description = "Google project ID"
}

variable "cluster" {
  type        = string
  default     = "airflow-stage"
  description = "k8s cluster name"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region"
}
