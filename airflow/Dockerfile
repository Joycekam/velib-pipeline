FROM apache/airflow:3.3.2

# Venv séparé : installer dbt à côté d'Airflow pourrait modifier
# des versions de librairies dont Airflow dépend
COPY requirements-pipeline.txt /tmp/requirements-pipeline.txt
RUN python -m venv /home/airflow/pipeline_venv \
    && /home/airflow/pipeline_venv/bin/pip install --no-cache-dir -r /tmp/requirements-pipeline.txt