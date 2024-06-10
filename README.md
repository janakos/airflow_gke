# Airflow GKE Project

## Overview

This project contains various configurations and scripts to deploy and manage Apache Airflow on Google Kubernetes Engine (GKE). It includes Terraform scripts for infrastructure management, Docker configurations for containerized services, and Kubernetes manifests for deployment.

## Directory Structure

- **00-cluster/**: Terraform scripts for setting up the GKE cluster.
- **03-newrelic/**: Configuration files for integrating New Relic monitoring.
- **05-stackgres/**: Configuration files for deploying StackGres.
- **08-airflow-postgres/**: Configuration for setting up postgres database.
- **10-airflow/**: Configuration for setting up Ariflow via HELM provided by official apache airflow repo
- **15-gateway/**: Configuration for setting up API Gateway.
  - **staging-load/**: YAML files for staging load balancers.
  - **staging-primary/**: YAML files for primary staging environment.
  - **gateway/**: External gateway configuration.
- **docker/**: Docker configurations and scripts.
  - **airflow/**: Docker setup for Airflow.
  - **custom-metrics/**: Custom metrics Docker setup.
  - **dag_sync/**: Script and Dockerfile for syncing DAGs.
- **.git/**: Git configuration files.
