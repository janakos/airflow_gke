resource "helm_release" "airflow" {
  for_each = toset(local.namespaces)

  name             = "airflow"
  repository       = "https://airflow.apache.org"
  chart            = "airflow"
  version          = "1.11.0"
  namespace        = each.value
  wait             = false
  create_namespace = false

  values = [
    file("values.yaml"),
    file("values-${each.value}.yaml")
  ]

  set {
    name  = "data.metadataConnection.host"
    value = "${local.postgres_name}.${each.value}.svc.cluster.local"
  }

  set {
    name  = "webserver.defaultUser.username"
    value = "gh-service-account"
  }

  set_sensitive {
    name  = "webserver.defaultUser.password"
    value = data.google_secret_manager_secret_version.gh_service_account_password.secret_data
  }

  set_sensitive {
    name  = "data.metadataConnection.pass"
    value = data.kubernetes_secret.postgres[each.value].data.superuser-password
  }

  set_sensitive {
    name  = "webserverSecretKey"
    value = base64encode(data.kubernetes_secret.airflow-key[each.value].data.webserver-key)
  }

  set_sensitive {
    name  = "fernetKey"
    value = base64encode(data.kubernetes_secret.airflow-key[each.value].data.fernet-key)
  }
}
