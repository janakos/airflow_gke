FROM apache/airflow:2.7.3-python3.11

WORKDIR /app
COPY metrics.py /app
RUN pip install newrelic-telemetry-sdk
CMD ["python", "./metrics.py"]
