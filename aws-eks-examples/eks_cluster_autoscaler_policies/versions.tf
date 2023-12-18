terraform {
  required_providers {




    helm = {
      source = "hashicorp/helm"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13"
}
