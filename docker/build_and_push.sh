
set -e

if [ "$#" -ne 1 ]; then echo "single arg expected"; exit; fi
if [[ $1 != "airflow" && $1 != "dag_sync" ]]; then echo "arg not supported"; exit; fi

cd "$1" || exit

docker build  --platform linux/amd64 -t "$1" .
docker tag "$1":latest us-central1-docker.pkg.dev/iguana-staging/airflow-gke/"$1":stable
docker push us-central1-docker.pkg.dev/iguana-staging/airflow-gke/"$1":stable
