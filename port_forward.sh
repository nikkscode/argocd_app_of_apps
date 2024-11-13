#!/bin/bash

# List of services with their namespaces and port pairs (localPort:servicePort)
SERVICES_TO_FORWARD=(
  "argocd:argocd-server:8080:80"
  "keycloak:keycloak:8081:80"
  "kubernetes-dashboard:kubernetes-dashboard-web:8082:8000"
)

# Loop through the services to set up port forwarding
for SERVICE in "${SERVICES_TO_FORWARD[@]}"; do
  NAMESPACE=$(echo $SERVICE | cut -d':' -f1)
  SERVICE_NAME=$(echo $SERVICE | cut -d':' -f2)
  LOCAL_PORT=$(echo $SERVICE | cut -d':' -f3)
  SERVICE_PORT=$(echo $SERVICE | cut -d':' -f4)

  echo "Starting port forward: Local Port $LOCAL_PORT -> $SERVICE_NAME in $NAMESPACE (Service Port $SERVICE_PORT)"

  # Run kubectl port-forward for the service in the background
  kubectl port-forward -n $NAMESPACE svc/$SERVICE_NAME $LOCAL_PORT:$SERVICE_PORT &
done

# Wait for all background jobs (port-forward processes) to finish
wait

echo "Port forwarding complete."
