terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.72.0"
    }

  }

  backend "azurerm" {
    resource_group_name  = "rg-curso-terraform"
    storage_account_name = "homailsonlopesterraform"
    container_name       = "remotestate"
    key                  = "pipeline-github/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner      = "homailson"
      managed-by = "terraform"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}


data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "homailson-lopes-passos-curso-terraform"
    key    = "aws-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-curso-terraform"
    storage_account_name = "homailsonlopesterraform"
    container_name       = "remotestate"
    key                  = "azure-vnet/terraform.tfstate"
  }
}