# cloud domain and secure gateway

## steps that need to be once manually due to api restrictions
1. create the oidc api client in the gcp console --
2. create the oidc secret for airflow webserver to consume in each namespace --
```
~ kubectl create secret generic airflow-oidc-secret --namespace=staging-primary --from-literal=GOOGLE_OAUTH2_CLIENT_ID=*** --from-literal=GOOGLE_OAUTH2_SECRET=***
~ kubectl get secret airflow-oidc-secret --namespace=staging-primary -oyaml | sed '/namespace/d' | sed '/creationTimestamp/d' | sed '/resourceVersion/d' | sed '/uid/d' | kubectl apply --namespace=staging-load -f -
# oidc values retrieved from  https://console.cloud.google.com/apis/credentials?project=iguana-staging
```

## step where it is unclear how to do as code as namespace is created by helm
1. label the namespaces for routing across from gateway namespace --
```
~ kubectl label namespaces staging-primary shared-gateway-access=true --overwrite=true
~ kubectl label namespaces staging-load shared-gateway-access=true --overwrite=true
```

## manual steps taken where it is possible to terraform
1. create managed cert for that domain --
```
~ gcloud compute ssl-certificates create af-staging-iguana-com \
    --domains=af-staging.iguana.com \
    --global
```

2. add the a record for the subdomain to expose gateway to af-staging.iguana.com --
```
~ kubectl get gateway external-http -o=jsonpath="{.status.addresses[0].value}"
# Add the A record manually for external gateway IP in the console https://console.cloud.google.com/net-services/dns/zones/iguana-com/details?project=iguana
```

3. setup cloud armor policy for zscaler allow list ip 
```
# https://console.cloud.google.com/net-security/securitypolicies/details/staging-airflow-webserver?project=iguana-staging
``` 
# TODO update the default * rule to deny once the zscaler ip(s) is confirmed