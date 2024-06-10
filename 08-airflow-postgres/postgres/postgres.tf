resource "kubectl_manifest" "instance" {
  yaml_body = templatefile("${path.module}/config/instance.yaml.tftpl", {
    namespace = var.namespace
  })
}

resource "kubectl_manifest" "pooling" {
  yaml_body = templatefile("${path.module}/config/pooling.yaml.tftpl", {
    namespace = var.namespace
  })
}

resource "kubectl_manifest" "postgres" {
  yaml_body = templatefile("${path.module}/config/postgres.yaml.tftpl", {
    namespace = var.namespace
    }
  )
}

resource "kubectl_manifest" "cluster" {
  yaml_body = templatefile("${path.module}/config/cluster.yaml.tftpl", {
    namespace = var.namespace
    }
  )
}
