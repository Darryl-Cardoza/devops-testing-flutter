# Main entrypoint for the configuration. It sets up the cloud providers
# and includes a random string generator to ensure globally unique names for resources like S3 buckets.

# This resource generates a random suffix to append to resource names,
# preventing naming conflicts with existing resources in the cloud.
resource "random_pet" "suffix" {
  length = 2
}

# Provider configurations are intentionally left blank.
# They will be automatically configured by the environment variables
# set by the GitHub Actions authentication steps in the CD workflow.
provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "azurerm" {
  features {}
}