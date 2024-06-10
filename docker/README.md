
# Using the build script
You can use the build_and_push.sh script to build either the Airflow image or the GCS sync sidecar and
push them to the relevant artifact repo. Use the script as follows to build either one:
```
./build_and_push airflow
```
or
```
./build_and_push dag_sync
```