
variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "artifact_repo_name" {
  type    = string
  default = "Toyota-salesbot-repo"
}

variable "cloud_run_sa_name" {
  type    = string
  default = "cloud-run-sa"
}

variable "service_name" {
  type    = string
  default = "Toyota-salesbot-service"
}

variable "placeholder_image_uri" {
  type    = string
  default = "gcr.io/cloudrun/hello"
}
