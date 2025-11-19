# # Contains all resource definitions for Google Cloud Platform.
#
# resource "google_storage_bucket" "artifact_storage" {
#   # Create this resource only if the enable_gcp flag is true.
#   count = var.enable_gcp ? 1 : 0
#
#   name          = "${var.project_name}-artifacts-${random_pet.suffix.id}"
#   location      = var.gcp_region
#   force_destroy = true # Allows the bucket to be deleted even if it contains objects.
#
#   labels = {
#     project      = var.project_name
#     managed-by   = "terraform"
#     version      = var.app_version
#   }
# }
