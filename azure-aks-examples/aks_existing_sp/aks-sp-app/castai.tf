data "azurerm_subscription" "current" {}

data "azuread_application" "castai" {
  display_name = var.azuread_application
}

resource "castai_aks_cluster" "this" {
  name = var.cluster_name

  region          = var.cluster_region
  subscription_id = data.azurerm_subscription.current.subscription_id
  tenant_id       = data.azurerm_subscription.current.tenant_id
  client_id       = data.azuread_application.castai.application_id
  client_secret   = var.azuread_application_password


  node_resource_group        = data.azurerm_kubernetes_cluster.this.node_resource_group
  delete_nodes_on_disconnect = var.delete_nodes_on_disconnect
}

data "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  resource_group_name = var.resource_group
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  }
}

resource "castai_node_configuration" "default" {
  cluster_id     = castai_aks_cluster.this.id
  name           = "default"
  disk_cpu_ratio = 0
  min_disk_size  = 100
  subnets        = var.subnets

  aks {
    max_pods_per_node = 40
  }
}

resource "castai_node_configuration_default" "this" {
  cluster_id       = castai_aks_cluster.this.id
  configuration_id = castai_node_configuration.default.id
}
