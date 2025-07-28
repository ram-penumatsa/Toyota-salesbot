
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "docker_repo" {
  name     = var.artifact_repo_name
  format   = "DOCKER"
  location = var.region
  description = "Docker repo for Streamlit Oracle chatbot"
}

resource "google_service_account" "cloud_run_sa" {
  account_id   = var.cloud_run_sa_name
  display_name = "Cloud Run Runtime Service Account"
}

resource "google_project_iam_member" "cloud_run_sa_secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_project_iam_member" "cloud_run_sa_registry_read" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_cloud_run_service" "chatbot" {
  name     = "Toyota-salesbot-service"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloud_run_sa.email
      containers {
        image = var.placeholder_image_uri
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "allow_all" {
  location = var.region
  service  = google_cloud_run_service.chatbot.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
