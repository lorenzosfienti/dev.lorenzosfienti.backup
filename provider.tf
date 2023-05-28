terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.63.0"
    }
  }

  # We store terraform terraform.tfstate on s3 in order to make it persistent and sharable.
  # https://www.terraform.io/docs/language/settings/backends/index.html 
  backend "s3" {
    bucket  = "lorenzosfienti-dev-terraform"
    key     = "terraform.backup.tfstate"
    region  = "us-east-1"
    profile = "lorenzosfienti"
  }
}

# Configure default AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "lorenzosfienti"
  default_tags {
    tags = {
      "ilpost:created-by"  = "terraform"
      "ilpost:project-url" = "https://github.com/lorenzosfienti/dev.lorenzosfienti.backup"
    }
  }
}
