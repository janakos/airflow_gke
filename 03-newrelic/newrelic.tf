
#resource "helm_release" "newrelic" {
#  name             = "iguana-newrelic"
#  repository       = "https://helm-charts.newrelic.com"
#  chart            = "nri-bundle"
#  version          = "5.0.67"
#  namespace        = "monitoring"
#  wait             = false
#  create_namespace = true
#
#  values = [
#    file("values.yaml")
#  ]
#
#  set {
#    name  = "global.cluster"
#    value = var.cluster
#  }
#  set_sensitive {
#    name  = "global.licenseKey"
#    value = data.google_secret_manager_secret_version.new_relic_license_key.secret_data
#  }
#}

resource "newrelic_one_dashboard_json" "airflow_dashboard" {
  json = templatefile("./newrelic_dashboard.json.tftpl", {
    cluster = var.cluster
  })
}

# Airflow deployment & GKE in general generates tons of metrics & we pay by the GB.
resource "newrelic_nrql_drop_rule" "drop_non_airflow" {
  account_id  = 3032839
  description = "Drops all non-airflow metrics from cluster ${local.cluster_name}"
  action      = "drop_data"
  nrql        = "FROM Metric SELECT * WHERE (clusterName = '${local.cluster_name}' or cluster_name = '${local.cluster_name}') AND metricName NOT LIKE 'airflow%'"
}

# This particular metric is both unused and bulky. That's a no-go.
resource "newrelic_nrql_drop_rule" "drop_airflow_task_sum" {
  account_id  = 3032839
  description = "Drops all non-airflow metrics from cluster ${local.cluster_name}"
  action      = "drop_data"
  nrql        = "FROM Metric SELECT * WHERE (clusterName = '${local.cluster_name}' or cluster_name = '${local.cluster_name}') AND metricName = 'airflow_task_duration_sum'"
}
