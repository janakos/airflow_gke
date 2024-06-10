module "postgres" {
  for_each = toset(local.namespaces)

  source    = "./postgres"
  namespace = each.value
}

resource "kubernetes_secret" "airflow-key" {
  for_each = toset(local.namespaces)

  metadata {
    name      = "airflow-secret-keys"
    namespace = each.value
  }

  data = {
    webserver-key = data.external.airflow-key["${each.value}-webserver"].result["key"]
    fernet-key    = data.external.airflow-key["${each.value}-fernet"].result["key"]
  }

  type = "Opaque"
}
