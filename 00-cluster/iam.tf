
data "google_service_account" "airflow_service_account" {
  account_id = local.sa_account_id
}

resource "google_service_account_iam_member" "primary_worker_gsa_ksa_binding" {
  for_each = toset(local.namespaces)

  service_account_id = data.google_service_account.airflow_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value}/${local.k8s_service_account_worker}]"
}

resource "google_service_account_iam_member" "primary_scheduler_gsa_ksa_binding" {
  for_each = toset(local.namespaces)

  service_account_id = data.google_service_account.airflow_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value}/${local.k8s_service_account_scheduler}]"
}

resource "google_service_account_iam_member" "primary_webserver_gsa_ksa_binding" {
  for_each = toset(local.namespaces)

  service_account_id = data.google_service_account.airflow_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value}/${local.k8s_service_account_webserver}]"
}
