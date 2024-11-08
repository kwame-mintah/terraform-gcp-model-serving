# Data source to get project details
data "google_project" "project" {}

locals {
  name_prefix = "${var.project_name}-${var.gcp_region}-${var.env_prefix}"
}


#---------------------------------------------------
# Bucket
#---------------------------------------------------
resource "google_storage_bucket" "mlflow_bucket" {
  name                        = "${local.name_prefix}-mlflow-bucket"
  location                    = "EU"
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  versioning {
    enabled = true
  }
}
