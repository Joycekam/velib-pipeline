variable "project_id" {
  description = "ID du projet Google Cloud"
  type        = string
  default     = "velib-data-pipeline"
}

variable "region" {
  description = "Région des ressources Google Cloud"
  type        = string
  default     = "europe-west1"
}

variable "bq_location" {
  description = "Zone des datasets dans BigQuery"
  type        = string
  default     = "EU"
}