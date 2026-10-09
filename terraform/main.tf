terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_bigquery_dataset" "raw" {
  dataset_id  = "raw"
  location    = var.bq_location
  description = "Reponse de l'API velib, sans aucune transformation"


  delete_contents_on_destroy = true #Permet de supprimer le dataset même s'il contient des tables

}

resource "google_bigquery_dataset" "staging" {
  dataset_id                 = "staging"
  location                   = var.bq_location
  description                = "données nettoyées et typées par dbt"
  delete_contents_on_destroy = true
}

resource "google_bigquery_dataset" "marts" {
  dataset_id                 = "marts"
  location                   = var.bq_location
  description                = " tables finales pour l'analyse et le dashboard"
  delete_contents_on_destroy = true
}