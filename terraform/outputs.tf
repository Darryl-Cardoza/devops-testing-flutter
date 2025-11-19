# Defines the output values from your Terraform configuration.
# These outputs can be used to easily find the resources that were created.

output "aws_s3_bucket_name" {
  description = "The name of the S3 bucket created for storing artifacts."
  value       = var.enable_aws ? aws_s3_bucket.artifact_storage[0].id : "Not created"
}


# output "gcp_storage_bucket_name" {
#   description = "The name of the Google Cloud Storage bucket created."
#   value       = var.enable_gcp ? google_storage_bucket.artifact_storage[0].name : "Not created"
# }
#
# output "azure_storage_container_name" {
#   description = "The name of the Azure Storage Container created."
#   value       = var.enable_azure ? azurerm_storage_container.artifacts[0].name : "Not created"
# }
