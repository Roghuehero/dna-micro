provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "whoami" {
  metadata {
    name = "whoami"
    labels = {
      App = "whoami"
    }
  }
  spec {
    replicas = 3

    selector {
      match_labels = {
        App = "whoami"
      }
    }

    template {
      metadata {
        labels = {
          App = "whoami"
        }
      }
      spec {
        container {
          name  = "whoami"
          image = "congtaojiang/whoami-nodejs-express"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "whoami_service" {
  metadata {
    name = "whoami-service"
  }
  spec {
    selector = {
      App = kubernetes_deployment.whoami.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "canary" {
  metadata {
    name = "whoami-canary"
    labels = {
      App = "whoami-canary"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "whoami-canary"
      }
    }

    template {
      metadata {
        labels = {
          App = "whoami-canary"
        }
      }
      spec {
        container {
          name  = "whoami-canary"
          image = "emilevauge/whoami"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "canary_service" {
  metadata {
    name = "whoami-canary-service"
  }
  spec {
    selector = {
      App = kubernetes_deployment.canary.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
