variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster to be connected to the CAST AI."
}

variable "resource_group" {
  type        = string
  description = "Azure resource group that contains the cluster."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "additional_resource_groups" {
  type    = list(string)
  default = []
}