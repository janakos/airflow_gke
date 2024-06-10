locals {
  namespaces = [
    "staging-primary",
    "staging-load"
  ]
  components = [
    "webserver",
    "fernet"
  ]
  keys = toset([for i in setproduct(local.namespaces, local.components) : join("-", i)])
}
