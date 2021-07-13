terraform {
  required_providers {
    kubernetes = {
      version  = "= 1.13.3"
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

resource "null_resource" "rename_node" {
  provisioner "local-exec" {
    command = "kubectl label nodes $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}') app=clearml"
  }
}

resource "null_resource" "update_docker_daemon" {
  provisioner "local-exec" {
    command = "echo '{\"default-ulimits\": {\"nofile\": {\"name\": \"nofile\",\"hard\": 65536,\"soft\": 1024},\"memlock\":{\"name\": \"memlock\",\"soft\": -1,\"hard\": -1}}}' > /etc/docker/daemon.json"
    interpreter = ["sudo", "bash", "-c"]
  }
}

resource "null_resource" "set_map_count" {
  provisioner "local-exec" {
    command = "echo 'vm.max_map_count=262144' > /tmp/99-clearml.conf && sudo mv /tmp/99-clearml.conf /etc/sysctl.d/99-clearml.conf && sudo sysctl -w vm.max_map_count=262144"
  }
}

resource "null_resource" "restart_docker" {
  provisioner "local-exec" {
    command = "service docker restart"
    interpreter = ["sudo", "bash", "-c"]
  }
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "clearml" {
  name       = "clearml"
  repository = "https://allegroai.github.io/clearml-server-helm-cloud-ready/"
  chart      = "clearml-server-cloud-ready"
  namespace  = var.namespace

  set {
    name  = "elasticsearch.esJavaOpts"
    value = var.es_JavaOpts
  }

  set {
    name  = "elasticsearch.resources.requests.memory"
    value = var.es_requestsMemory
  }

  set {
    name  = "elasticsearch.resources.limits.memory"
    value = var.es_limitsMemory
  }
}

