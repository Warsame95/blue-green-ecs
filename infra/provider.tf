terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.35.1"
    }
  }
  backend "s3" {
    bucket       = "warsame-url-shortener"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true

  }
}

provider "aws" {
  region = "eu-west-2"
}