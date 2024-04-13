# GKE module variables.
variable "cluster_name" {
  type        = string
  description = "GKE cluster name in GCP project."
}

variable "cluster_region" {
  type        = string
  description = "The region to create the cluster."
}

variable "cluster_zones" {
  type        = list(string)
  description = "The zones to create the cluster."
}

variable "project_id" {
  type        = string
  description = "GCP project ID in which GKE cluster would be created."
}

