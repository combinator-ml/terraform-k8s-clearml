variable "namespace" {
  description = "The namespace to deploy ClearML into"
  type        = string
  default     = "clearml"
}

variable "es_JavaOpts" {
  description = "The JavaOpts for ElasticSearch"
  type        = string
  default     = "-Xmx500m -Xms500m"
}

variable "es_requestsMemory" {
  description = "The memory that ElasticSearch requests"
  type        = string
  default     = "1Gi"
}

variable "es_limitsMemory" {
  description = "The limit on memory that ElasticSearch can use"
  type        = string
  default     = "1Gi"
}