resource "kubernetes_namespace_v1" "argocd_ns" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/part-of" = "argocd"
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = kubernetes_namespace_v1.argocd_ns.metadata[0].name
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  create_namespace = false

  values = [
    yamlencode({
      crds = {
        install = true
      }

      global = {
        domain = ""
      }

      configs = {
        params = {
          "server.insecure" = "true"
        }
      }

      server = {
        service = {
          type = "ClusterIP"
        }
      }

      dex = {
        enabled = true
      }

      redis = {
        enabled = true
      }

      controller = {
        replicas = 1
      }

      repoServer = {
        replicas = 1
      }

      applicationSet = {
        replicas = 1
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.argocd_ns
  ]
}
