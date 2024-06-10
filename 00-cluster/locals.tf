locals {

  namespaces = [
    "staging-primary",
    "staging-load"
  ]

  sa_account_id = "iguana-composer-staging"
  dag_bucket    = "iguana-airflow-staging"

  k8s_service_account_worker    = "gke-access-worker"
  k8s_service_account_scheduler = "gke-access-scheduler"
  k8s_service_account_webserver = "gke-access-webserver"
}