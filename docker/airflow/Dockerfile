FROM apache/airflow:2.7.3-python3.11

WORKDIR ${AIRFLOW_HOME}

USER root
RUN set -ex \
    && export ACCEPT_EULA=Y \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
           python3-dev \
           gcc \
           g++ \
    && apt-get purge --auto-remove \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
USER airflow

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p ${AIRFLOW_HOME}/gcloud \
  && tar -C ${AIRFLOW_HOME}/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && ${AIRFLOW_HOME}/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:${AIRFLOW_HOME}/gcloud/google-cloud-sdk/bin

# Copy requirements/constraints into image
COPY requirements.txt requirements.txt
COPY constraints.txt constraints.txt
RUN pip3 install -r requirements.txt -c constraints.txt

COPY webserver_config.py ${AIRFLOW_HOME}/webserver_config.py

USER airflow
