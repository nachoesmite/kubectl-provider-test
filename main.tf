
terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  config_context = "kind-kind"
}

data "kubectl_file_documents" "docs" {
  content = templatefile("${path.module}/manifests/deployment.yaml", {
    image_name     = var.image_name
    image_version  = var.image_version
  })
}

resource "kubectl_manifest" "dev-api2" {
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value
}
