output "namespace" {
  value = kubernetes_namespace_v1.argocd_ns.metadata[0].name
}

output "helm_release_name" {
  value = helm_release.argocd.name
}
