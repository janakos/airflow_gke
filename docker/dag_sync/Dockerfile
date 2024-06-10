FROM gcr.io/cloud-marketplace/google/debian11:latest

RUN apt-get update -y
RUN apt install curl -y

ENV PATH=/google-cloud-sdk/bin:$PATH

WORKDIR /
RUN export CLOUD_SDK_VERSION="410.0.0" && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64

RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_images && \
    gcloud -q components install gsutil

COPY sync.sh /opt/scripts/sync.sh

RUN useradd -r -u 50000 -m -s /bin/bash -g root airflow
USER airflow

ENTRYPOINT ["/opt/scripts/sync.sh"]
