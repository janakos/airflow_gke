#!/bin/sh -e

if [ -z "${DAG_BUCKET}" ] || [ -z "${PATH_PREFIX}" ]; then
    echo "DAG_BUCKET and PATH_PREFIX must be set to execute script."
    exit 1
fi

gcsGet () {
    echo "Syncing DAGs from GCS"
    gsutil -m rsync -r -x '.*\.pyc$' -d gs://"$DAG_BUCKET"/"$PATH_PREFIX"/dags /opt/airflow/dags/
    echo "Syncing plugins from GCS"
    gsutil -m rsync -r -x '.*\.pyc$' -d gs://"$DAG_BUCKET"/"$PATH_PREFIX"/plugins /opt/airflow/plugins/
    echo "Finished downloading from GCS"
}

while true; do
  gcsGet
  sleep $DAG_SYNC_INTERVAL
done
