# Ingestion des données Velib dans le raw de BigQuery

# Ici, chaque exécution ajoute une ligne dans la table raw, avec un timestamp d'ingestion. Cela permet de garder un historique des données.

import requests
import json
import logging
import os
from datetime import datetime, timezone

from dotenv import load_dotenv
from google.cloud import bigquery

load_dotenv()

PROJECT_ID = os.environ["GCP_PROJECT"]
DATASET = os.getenv("BQ_RAW_DATASET", "raw")
LOCATION = os.getenv("BQ_LOCATION", "EU")

BASE_URL = "https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole"
FEEDS = {
    "station_status": f"{BASE_URL}/station_status.json",
    "station_information": f"{BASE_URL}/station_information.json",
}

SCHEMA = [
    bigquery.SchemaField("ingested_at", "TIMESTAMP", mode="REQUIRED"),
    bigquery.SchemaField("source_url", "STRING", mode="REQUIRED"),
    bigquery.SchemaField("payload", "STRING", mode="REQUIRED")
]

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

def extract(url):
    reponse = requests.get(url, timeout=30)
    reponse.raise_for_status()

    json.loads(reponse.text)  # Vérifie que le JSON est valide avant de le stocker

    return reponse.text

def load(client, table_name, row):
    table_id = f"{PROJECT_ID}.{DATASET}.{table_name}"

    job_config = bigquery.LoadJobConfig(
        schema=SCHEMA,
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
        time_partitioning=bigquery.TimePartitioning(field="ingested_at")
    )

    # Lancer le job de chargement
    load_job = client.load_table_from_json([row], table_id, job_config=job_config, location=LOCATION)
    load_job.result()

    logger.info("%s : 1 ligne chargéé dans %s", table_name, table_id)

def main():
    client = bigquery.Client(project=PROJECT_ID)
    ingested_at = datetime.now(timezone.utc).isoformat()
    failed = []

    for table_name, url in FEEDS.items():
        try:
            payload = extract(url)
            row = {
                "ingested_at": ingested_at,
                "source_url": url,
                "payload": payload
            }
            load(client, table_name, row)
        except Exception :
            logger.exception("Erreur lors de l'ingestion de %s", table_name)
            failed.append(table_name)

    if failed:
        raise RuntimeError(f"Ingestion echoué par: {', '.join(failed)}")

if __name__ == "__main__":
    main()
    