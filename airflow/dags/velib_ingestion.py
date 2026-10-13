"""Collecte des flux Vélib dans la couche bronze, toutes les 15 minutes."""

from datetime import timedelta

import pendulum
from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import DAG

VENV_BIN = "/home/airflow/pipeline_venv/bin"
PROJECT_DIR = "/opt/airflow/project"

with DAG(
    dag_id="velib_ingestion",
    schedule="*/15 * * * *",
    start_date=pendulum.datetime(2026, 10, 1, tz="Europe/Paris"),
    catchup=False,
    max_active_runs=1,
    default_args={"retries": 2, "retry_delay": timedelta(minutes=2)},
    tags=["velib"],
):
    BashOperator(
        task_id="ingest_velib_feeds",
        bash_command=f"{VENV_BIN}/python {PROJECT_DIR}/ingestion/ingest_velib.py",
    )