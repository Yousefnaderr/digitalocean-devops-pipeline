#!/usr/bin/env bash
# ----------------------------------------------------
# Script: deploy-monitoring.sh
# Purpose: Deploy Prometheus, Grafana, Loki & Promtail stack for Swipebay
# Author: Youssef
# ----------------------------------------------------

NAMESPACE="monitoring"

# Ensure namespace exists
if ! kubectl get ns $NAMESPACE >/dev/null 2>&1; then
  kubectl create ns $NAMESPACE
fi

echo "Deploying Prometheus & Grafana via Helm..."
helm upgrade --install monitoring kube-prometheus-stack-78.1.0.tgz \
  -n $NAMESPACE -f monitoring-values.yaml

echo "Deploying Loki..."
kubectl apply -f loki-config.yaml -n $NAMESPACE
kubectl apply -f loki-service-deployment.yml -n $NAMESPACE
kubectl apply -f loki-ingress.yml -n $NAMESPACE

echo "Deploying Promtail..."
kubectl apply -f promtail-rbac.yaml -n $NAMESPACE
kubectl apply -f promtail-config.yaml -n $NAMESPACE
kubectl apply -f promtail-deploy.yaml -n $NAMESPACE

echo "Monitoring stack deployed successfully!"

