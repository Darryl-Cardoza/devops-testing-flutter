# Declares all the input variables for the Terraform configuration.
# Defaults are provided for convenience, but these can be overridden from the command line or .tfvars files.

variable "app_version" {
  description = "The version of the application being deployed."
  type        = string
}

variable "project_name" {
  description = "A short name for the project, used to prefix resource names."
  type        = string
  default     = "flutter-app"
}

# --- Cloud Provider Flags ---
variable "enable_aws" {
  description = "Set to true to provision resources on AWS."
  type        = bool
  default     = false
}

variable "enable_gcp" {
  description = "Set to true to provision resources on GCP."
  type        = bool
  default     = false
}

variable "enable_azure" {
  description = "Set to true to provision resources on Azure."
  type        = bool
  default     = false
}


# --- AWS Variables ---
variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

# --- GCP Variables ---
variable "gcp_project_id" {
  description = "The GCP Project ID to deploy resources into."
  type        = string
  # This should be set in your GitHub repository variables/secrets
  default = ""
}

variable "gcp_region" {
  description = "The GCP region where resources will be created."
  type        = string
  default     = "us-central1"
}

# --- Azure Variables ---
variable "azure_resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
  default     = "flutter-app-releases"
}

variable "azure_location" {
  description = "The Azure location (region) where resources will be created."
  type        = string
  default     = "East US"
}
