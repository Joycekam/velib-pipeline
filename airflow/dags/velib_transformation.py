"""Construction et tests des modèles dbt, une fois par jour."""

from datetime import timedelta

import pendulum
from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import DAG

VENV_BIN = "/home/airflow/pipeline_venv/bin"
DBT_DIR = "/opt/airflow/project/dbt"

with DAG(
    dag_id="velib_transformation",
    schedule="0 6 * * *",
    start_date=pendulum.datetime(2026, 10, 1, tz="Europe/Paris"),
    catchup=False,
    max_active_runs=1,
    default_args={"retries": 1, "retry_delay": timedelta(minutes=5)},
    tags=["velib"],
):
    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command=f"cd {DBT_DIR} && {VENV_BIN}/dbt deps",
    )

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command=f"cd {DBT_DIR} && {VENV_BIN}/dbt build --profiles-dir {DBT_DIR}",
    )

    dbt_deps >> dbt_build