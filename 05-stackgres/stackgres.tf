resource "helm_release" "stackgres-operator" {
  name             = "stackgres"
  repository       = "https://stackgres.io/downloads/stackgres-k8s/stackgres/helm"
  chart            = "stackgres-operator"
  version          = "1.9"
  namespace        = "stackgres"
  wait             = true
  create_namespace = true
}
