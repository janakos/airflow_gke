resource "kubernetes_namespace" "gateway" {
  metadata {
    name = "gateway"
  }
}

resource "kubernetes_manifest" "external-gateway" {
  depends_on = [resource.kubernetes_namespace.gateway]

  manifest = yamldecode(file("gateway/external-gateway.yaml"))
}

resource "kubernetes_manifest" "http-route" {
  manifest = yamldecode(file("staging-primary/http-route.yaml"))
}

resource "kubernetes_manifest" "healthcheck-policy" {
  manifest = yamldecode(file("staging-primary/healthcheck-policy.yaml"))
}

# resource "kubernetes_manifest" "backend-policy" {
#   manifest = yamldecode(file("staging-primary/backend-policy.yaml"))
# }

resource "kubernetes_manifest" "http-route-load" {
  manifest = yamldecode(file("staging-load/http-route.yaml"))
}

resource "kubernetes_manifest" "healthcheck-policy-load" {
  manifest = yamldecode(file("staging-load/healthcheck-policy.yaml"))
}

# resource "kubernetes_manifest" "backend-policy-load" {
#   manifest = yamldecode(file("staging-load/backend-policy.yaml"))
# }