# Contains all resource definitions for AWS.
# The 'count' meta-argument ensures that resources are only created if 'var.enable_aws' is true.

resource "aws_s3_bucket" "artifact_storage" {
  # This conditional logic creates the resource only if the enable_aws flag is true.
  count = var.enable_aws ? 1 : 0

  # The bucket name is constructed from the project name and the random suffix to ensure uniqueness.
  bucket = "${var.project_name}-artifacts-${random_pet.suffix.id}"

  tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Version     = var.app_version
  }
}
