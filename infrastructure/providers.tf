terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
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

provider "github" {
  owner = var.github_organization
}