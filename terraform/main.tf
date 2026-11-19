
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = "minikube"
}

resource "kubernetes_namespace_v1" "deployforge" {
  metadata {
    name = "deployforge"
  }
}


resource "kubernetes_deployment_v1" "deployforge" {
  metadata {
    name      = "deployforge"
    namespace = kubernetes_namespace_v1.deployforge.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "deployforge"
      }
    }

    template {
      metadata {
        labels = {
          app = "deployforge"
        }
      }

      spec {
        container {
          name  = "deployforge-api"
          image = "deployforge:1.0"

          image_pull_policy = "Never"

          port {
            container_port = 8000
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 8000
            }

            initial_delay_seconds = 3
            period_seconds        = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "deployforge" {
  metadata {
    name      = "deployforge-service"
    namespace = kubernetes_namespace_v1.deployforge.metadata[0].name
  }

  spec {
    selector = {
      app = "deployforge"
    }

    port {
      port        = 8000
      target_port = 8000
    }

    type = "ClusterIP"
  }
}
