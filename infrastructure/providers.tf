terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = merge(var.tags, {
      Purpose   = "hashiconf-activations"
      Terraform = true
    })
  }
}