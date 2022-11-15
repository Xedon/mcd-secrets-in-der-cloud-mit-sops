terraform {
  required_version = "> 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.0"
    }
  }

}
