terraform {
  required_providers {
    kubernetes = {
      version = "= 1.13.3"
    }
    helm = {
      version = "= 2.1.2"
    }
  }
  required_version = ">= 0.12"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
   config_path = "~/.kube/config"
 }
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "clearml"
  }
}

resource "helm_release" "clear_ml" {
  name = "clearml"
  repository = "https://allegroai.github.io/clearml-server-helm-cloud-ready/"
  chart = "clearml-server-cloud-ready"

  namespace = "clearml"

  set {
    name = "elasticsearch.bootstrap.memory_lock"
    value = "false"
  }
}
