# Data source to get project details
data "google_project" "project" {}

locals {
  name_prefix = "${var.project_name}-${var.gcp_region}-${var.env_prefix}"
  github_actions_roles = [
    "roles/artifactregistry.writer",
    "roles/iam.serviceAccountTokenCreator",
    "roles/serverless.serviceAgent",
    "roles/run.admin",
  ]
}


#---------------------------------------------------
# Bucket
#---------------------------------------------------
#trivy:ignore:AVD-GCP-0066
resource "google_storage_bucket" "mlflow_bucket" {
  #checkov:skip=CKV_GCP_62:out of scope for demonstration, won't be adding a logging bucket
  name                        = "${local.name_prefix}-mlflow-bucket"
  location                    = "EU"
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  project                     = data.google_project.project.number
  versioning {
    enabled = true
  }
}

#---------------------------------------------------
# Registry
#---------------------------------------------------
resource "google_artifact_registry_repository" "prediction_service_registry" {
  #checkov:skip=CKV_GCP_84:out of scope for demonstration, wont be creating a kms key involves additional permissions for service account
  location      = var.gcp_region
  repository_id = "${var.env_prefix}-prediction-service"
  description   = "Docker registry for prediction microservice"
  format        = "DOCKER"
  # project       = data.google_project.project.id


  docker_config {
    immutable_tags = true
  }
}

#---------------------------------------------------
# Service Accounts
#---------------------------------------------------
resource "google_service_account" "prediction_service_account" {
  account_id   = "${var.env_prefix}-prediction-service-account"
  display_name = "Prediction Service Account"
  description  = "The service account needed to download from mlflow bucket"
}

resource "google_service_account" "github_actions_service_account" {
  count        = var.env_prefix == "dev" ? 1 : 0
  account_id   = "${var.env_prefix}-github-act-service-account"
  display_name = "GitHub Actions Service Account"
  description  = "The service account needed for GitHub actions workflows"
}

#---------------------------------------------------
# Service Accounts Keys
#---------------------------------------------------
resource "google_service_account_key" "github_actions_service_account_key" {
  count              = var.env_prefix == "dev" ? 1 : 0
  service_account_id = google_service_account.github_actions_service_account[0].name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "google_service_account_key" "prediction_service_account_key" {
  service_account_id = google_service_account.prediction_service_account.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}


#---------------------------------------------------
# IAM Policy Bindings
#---------------------------------------------------
resource "google_project_iam_binding" "github_actions_registry_role" {
  count = var.env_prefix == "dev" ? length(local.github_actions_roles) : 0

  project = data.google_project.project.number
  role    = local.github_actions_roles[count.index]
  members = [
    "serviceAccount:${google_service_account.github_actions_service_account[0].account_id}@${data.google_project.project.project_id}.iam.gserviceaccount.com"
  ]

  depends_on = [google_service_account.github_actions_service_account]
}


resource "google_project_iam_binding" "prediction_service_account_role" {
  project = data.google_project.project.number
  role    = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${google_service_account.prediction_service_account.account_id}@${data.google_project.project.project_id}.iam.gserviceaccount.com"
  ]

  depends_on = [google_service_account.prediction_service_account]
}
