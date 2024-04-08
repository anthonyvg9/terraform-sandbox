variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster to be connected to the CAST AI."
}

variable "cluster_region" {
  type        = string
  description = "Region of the cluster to be connected to CAST AI."
}

variable "resource_group" {
  type        = string
  description = "Azure resource group that contains the cluster."
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs used by CAST AI to provision nodes."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "additional_resource_groups" {
  type    = list(string)
  default = []
}

variable "delete_nodes_on_disconnect" {
  type        = bool
  description = "Optionally delete Cast AI created nodes when the cluster is destroyed."
  default     = true
}

variable "castai_api_url" {
  type        = string
  description = "CAST AI url to API, default value is https://api.cast.ai"
  default     = "https://api.cast.ai"
}

variable "castai_api_token" {
  type        = string
  description = "CAST AI API token created in console.cast.ai API Access keys section."
}

#CAST AI Components Variables: 
variable "autoscaler_policies_json" {
  type        = string
  description = "Optional json object to override CAST AI cluster autoscaler policies"
  default     = null
}


variable "api_url" {
  type        = string
  description = "URL of alternative CAST AI API to be used during development or testing"
  default     = "https://api.cast.ai"
}

variable "grpc_url" {
  type        = string
  description = "gRPC endpoint used by pod-pinner"
  default     = "grpc.cast.ai:443"
}

variable "castai_components_labels" {
  type        = map(any)
  description = "Optional additional Kubernetes labels for CAST AI pods"
  default     = {}
}

variable "castai_components_sets" {
  type        = map(string)
  description = "Optional additional 'set' configurations for helm resources."
  default     = {}
}

variable "install_security_agent" {
  type        = bool
  default     = false
  description = "Optional flag for installation of security agent (https://docs.cast.ai/product-overview/console/security-insights/)"
}

variable "agent_values" {
  description = "List of YAML formatted string values for agent helm chart"
  type        = list(string)
  default     = []
}

variable "spot_handler_values" {
  description = "List of YAML formatted string values for spot-handler helm chart"
  type        = list(string)
  default     = []
}

variable "cluster_controller_values" {
  description = "List of YAML formatted string values for cluster-controller helm chart"
  type        = list(string)
  default     = []
}

variable "evictor_values" {
  description = "List of YAML formatted string values for evictor helm chart"
  type        = list(string)
  default     = []
}

variable "kvisor_values" {
  description = "List of YAML formatted string values for kvisor helm chart"
  type        = list(string)
  default     = []
}

variable "agent_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = null
}

variable "spot_handler_version" {
  description = "Version of castai-spot-handler helm chart. If not provided, latest version will be used."
  type        = string
  default     = null
}

variable "cluster_controller_version" {
  description = "Version of castai-cluster-controller helm chart. If not provided, latest version will be used."
  type        = string
  default     = null
}

variable "evictor_version" {
  description = "Version of castai-evictor chart. If not provided, latest version will be used."
  type        = string
  default     = null
}

variable "kvisor_version" {
  description = "Version of kvisor chart. If not provided, latest version will be used."
  type        = string
  default     = "0.16.74"
}

variable "wait_for_cluster_ready" {
  type        = bool
  description = "Wait for cluster to be ready before finishing the module execution, this option requires `castai_api_token` to be set"
  default     = false
}

variable "azuread_application" {
  type        = string
  description = "Azure Appliction Registration to be used by CAST AI"
}

variable "azuread_application_password" {
  type        = string
  description = "App Registation Password"
  sensitive = true
}