import logging
import os

from newrelic_telemetry_sdk import GaugeMetric, MetricClient

if "NEW_RELIC_LICENSE_KEY" not in os.environ:
    print("NEW_RELIC_LICENSE_KEY not set in environment. Exiting.")
    exit(1)

if "NAMESPACE" not in os.environ:
    print("NAMESPACE not set in environment. Exiting.")
    exit(1)

if "CLUSTER_NAME" not in os.environ:
    print("CLUSTER_NAME not set in environment. Exiting.")
    exit(1)

TAG_LATEST_CRITICAL_PATH = "latest_pipeline:critical_path"
TAG_BATCH_CRITICAL_PATH = "batch_pipeline:critical_path"
TAGS_CRITICAL_PATH = [TAG_LATEST_CRITICAL_PATH, TAG_BATCH_CRITICAL_PATH]

metric_client = MetricClient(os.environ["NEW_RELIC_LICENSE_KEY"])


def get_task_duration():
    """
    Query the metadata DB for the duration of all running tasks.
    Write results back to NewRelic.
    """
    from datetime import datetime

    import pytz
    from airflow import settings
    from airflow.models import TaskInstance
    from airflow.utils.state import State
    from sqlalchemy import or_

    session = settings.Session()
    batch = []
    for task in (
        session.query(TaskInstance)
        .filter(
            or_(
                TaskInstance.state == State.RUNNING,
                TaskInstance.state == State.QUEUED,
            )
        )
        .all()
    ):
        # Differentiate between queued time and running time so we can set up different
        # alert conditions for the two.
        if task.state == "queued":
            duration = (
                pytz.utc.localize(datetime.now()) - task.queued_dttm
            ).seconds // 60
        elif task.state == "running":
            duration = (
                pytz.utc.localize(datetime.now()) - task.start_date
            ).seconds // 60
        else:
            # Should not happen given the current filter, more a defensive programming bit if we
            # later add more states to track, and we need to figure out different duration logic
            # for that. Skip to next data point/early return.
            continue
        tags = {
            "dag_id": task.dag_id,
            "task_id": task.task_id,
            "task_state": task.state,
            "cluster": os.environ["CLUSTER_NAME"],
            "namespace": os.environ["NAMESPACE"],
        }
        task_duration = GaugeMetric("airflow_task_duration", duration, tags)
        batch.append(task_duration)
        logging.info(
            f"Task duration metrics - task_id: {task.task_id}, dag_id: {task.dag_id}, start_date: {task.start_date}, duration_minutes: {duration}, task_state: {task.state}"
        )
    response = metric_client.send_batch(batch)
    response.raise_for_status()


def get_dag_duration():
    """
    Query the metadata DB for the duration of all running DAGs.
    Write results back to NewRelic.
    """
    from datetime import datetime

    import pytz
    from airflow import settings
    from airflow.models import DagRun
    from airflow.utils.state import State

    batch = []
    session = settings.Session()
    for dag in session.query(DagRun).filter(DagRun.state == State.RUNNING).all():
        # Calculate duration of task from queued datetime in minutes
        duration = int(
            (pytz.utc.localize(datetime.now()) - dag.queued_at).total_seconds() // 60
        )
        tags = {
            "dag_id": dag.dag_id,
            "cluster": os.environ["CLUSTER_NAME"],
            "namespace": os.environ["NAMESPACE"],
        }
        dag_duration = GaugeMetric("airflow_dag_duration", duration, tags)
        batch.append(dag_duration)
        logging.info(
            f"DAG duration metric - dag_id: {dag.dag_id}, queued_at: {dag.queued_at}, duration_minutes: {duration}"
        )
    response = metric_client.send_batch(batch)
    response.raise_for_status()


def get_paused_critical_dags():
    """
    Query the metadata db for all DagModel info.
    If DAG is critical and paused, write results back to NewRelic.
    """

    from airflow import settings
    from airflow.models import DagModel, DagTag

    # Query db for task info
    session = settings.Session()
    batch = []
    for dag in (
        session.query(DagModel)
        .join(DagTag)
        .filter(DagModel.is_paused == True)
        .filter(DagModel.is_active == True)
        .filter(DagTag.name.in_(TAGS_CRITICAL_PATH))
        .all()
    ):
        tags = {
            "dag_id": dag.dag_id,
            "cluster": os.environ["CLUSTER_NAME"],
            "namespace": os.environ["NAMESPACE"],
        }
        paused_dag = GaugeMetric("airflow_paused_critical_dag", 1, tags)
        batch.append(paused_dag)
        logging.info(
            f"Paused DAG Metric - DAG: {dag.dag_id}, Cluster: {tags['cluster']}, Namespace: {tags['namespace']}"
        )
    response = metric_client.send_batch(batch)
    response.raise_for_status()


get_task_duration()
get_dag_duration()
get_paused_critical_dags()
