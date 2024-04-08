resource "helm_release" "castai_agent" {
  name             = "castai-agent"
  repository       = "https://castai.github.io/helm-charts"
  chart            = "castai-agent"
  namespace        = "castai-agent"
  create_namespace = true
  cleanup_on_fail  = true
  wait             = true

  version = var.agent_version
  values  = var.agent_values

  set {
    name  = "replicaCount"
    value = "2"
  }
  set {
    name  = "provider"
    value = "aks"
  }

  set {
    name  = "createNamespace"
    value = "false"
  }

  dynamic "set" {
    for_each = var.api_url != "" ? [var.api_url] : []
    content {
      name  = "apiURL"
      value = var.api_url
    }
  }

  dynamic "set" {
    for_each = var.castai_components_labels
    content {
      name  = "podLabels.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.castai_components_sets
    content {
      name  = set.key
      value = set.value
    }
  }

  set_sensitive {
    name  = "apiKey"
    value = castai_aks_cluster.this.cluster_token
  }
}

resource "helm_release" "castai_evictor" {
  name             = "castai-evictor"
  repository       = "https://castai.github.io/helm-charts"
  chart            = "castai-evictor"
  namespace        = "castai-agent"
  create_namespace = true
  cleanup_on_fail  = true
  wait             = true

  version = var.evictor_version
  values  = var.evictor_values

  set {
    name  = "replicaCount"
    value = "0"
  }

  dynamic "set" {
    for_each = var.castai_components_labels
    content {
      name  = "podLabels.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.castai_components_sets
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [helm_release.castai_agent]

  lifecycle {
    ignore_changes = [set, version]
  }
}

resource "helm_release" "castai_cluster_controller" {
  name             = "cluster-controller"
  repository       = "https://castai.github.io/helm-charts"
  chart            = "castai-cluster-controller"
  namespace        = "castai-agent"
  create_namespace = true
  cleanup_on_fail  = true
  wait             = true

  version = var.cluster_controller_version
  values  = var.cluster_controller_values

  set {
    name  = "aks.enabled"
    value = "true"
  }

  set {
    name  = "castai.clusterID"
    value = castai_aks_cluster.this.id
  }

  dynamic "set" {
    for_each = var.api_url != "" ? [var.api_url] : []
    content {
      name  = "castai.apiURL"
      value = var.api_url
    }
  }

  dynamic "set" {
    for_each = var.castai_components_labels
    content {
      name  = "podLabels.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.castai_components_sets
    content {
      name  = set.key
      value = set.value
    }
  }

  set_sensitive {
    name  = "castai.apiKey"
    value = castai_aks_cluster.this.cluster_token
  }

  depends_on = [helm_release.castai_agent]

  lifecycle {
    ignore_changes = [version]
  }
}

resource "null_resource" "wait_for_cluster" {
  count      = var.wait_for_cluster_ready ? 1 : 0
  depends_on = [helm_release.castai_cluster_controller, helm_release.castai_agent]

  provisioner "local-exec" {
    environment = {
      API_KEY = var.castai_api_token
    }
    command = <<-EOT
        RETRY_COUNT=30
        POOLING_INTERVAL=30

        for i in $(seq 1 $RETRY_COUNT); do
            sleep $POOLING_INTERVAL
            curl -s ${var.api_url}/v1/kubernetes/external-clusters/${castai_aks_cluster.this.id} -H "x-api-key: $API_KEY" | grep '"status"\s*:\s*"ready"' && exit 0
        done

        echo "Cluster is not ready after 15 minutes"
        exit 1
    EOT

    interpreter = ["bash", "-c"]
  }
}

resource "helm_release" "castai_pod_pinner" {
  name             = "castai-pod-pinner"
  repository       = "https://castai.github.io/helm-charts"
  chart            = "castai-pod-pinner"
  namespace        = "castai-agent"
  create_namespace = true
  cleanup_on_fail  = true
  wait             = true

  set {
    name  = "castai.clusterID"
    value = castai_aks_cluster.this.id
  }

  dynamic "set" {
    for_each = var.api_url != "" ? [var.api_url] : []
    content {
      name  = "castai.apiURL"
      value = var.api_url
    }
  }

  set_sensitive {
    name  = "castai.apiKey"
    value = castai_aks_cluster.this.cluster_token
  }

  dynamic "set" {
    for_each = var.grpc_url != "" ? [var.grpc_url] : []
    content {
      name  = "castai.grpcURL"
      value = var.grpc_url
    }
  }

  dynamic "set" {
    for_each = var.castai_components_labels
    content {
      name  = "podLabels.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.castai_components_sets
    content {
      name  = set.key
      value = set.value
    }
  }

  set {
    name  = "replicaCount"
    value = "0"
  }

  depends_on = [helm_release.castai_agent]

  lifecycle {
    ignore_changes = [set, version]
  }
}

resource "helm_release" "castai_spot_handler" {
  name             = "castai-spot-handler"
  repository       = "https://castai.github.io/helm-charts"
  chart            = "castai-spot-handler"
  namespace        = "castai-agent"
  create_namespace = true
  cleanup_on_fail  = true
  wait             = true

  version = var.spot_handler_version
  values  = var.spot_handler_values

  set {
    name  = "castai.provider"
    value = "azure"
  }

  set {
    name  = "createNamespace"
    value = "false"
  }

  dynamic "set" {
    for_each = var.api_url != "" ? [var.api_url] : []
    content {
      name  = "castai.apiURL"
      value = var.api_url
    }
  }

  dynamic "set" {
    for_each = var.castai_components_labels
    content {
      name  = "podLabels.${set.key}"
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.castai_components_sets
    content {
      name  = set.key
      value = set.value
    }
  }

  set {
    name  = "castai.clusterID"
    value = castai_aks_cluster.this.id
  }

  depends_on = [helm_release.castai_agent]
}

resource "helm_release" "castai_kvisor" {
  count = var.install_security_agent == true ? 1 : 0

  name             = "castai-kvisor"
  repository       = "https://castai.github.io/helm-charts"
  chart            = "castai-kvisor"
  namespace        = "castai-agent"
  create_namespace = true
  cleanup_on_fail  = true

  version = var.kvisor_version
  values  = var.kvisor_values

  set {
    name  = "castai.apiURL"
    value = var.api_url
  }

  set {
    name  = "castai.clusterID"
    value = castai_aks_cluster.this.id
  }

  set {
    name  = "structuredConfig.provider"
    value = "aks"
  }

  dynamic "set" {
    for_each = var.castai_components_sets
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "castai_autoscaler" "castai_autoscaler_policies" {
  autoscaler_policies_json = var.autoscaler_policies_json
  cluster_id               = castai_aks_cluster.this.id

  depends_on = [helm_release.castai_agent, helm_release.castai_evictor]
} 