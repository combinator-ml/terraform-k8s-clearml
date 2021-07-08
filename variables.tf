variable "kubernetes_version" {
  description = "Version of Kubernetes to use"
  type        = string
  default     = "= 1.13.3"  
}

variable "helm_version" {
  description = "Version of Helm to use"
  type        = string
  default     = "= 2.1.2"  
}

variable "namespace" {
  description = "The namespace to deploy ClearML into"
  type        = string
  default     = "clearml"
}