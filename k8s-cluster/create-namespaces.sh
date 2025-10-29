#!/usr/bin/env bash
# ----------------------------------------------------
# Script: create-namespaces.sh
# Purpose: Automatically create required namespaces for Swipebay project
# Author: Youssef
# ----------------------------------------------------

namespaces=("backend" "frontend" "invoice" "storage")

for ns in "${namespaces[@]}"; do
  if ! kubectl get namespace "$ns" >/dev/null 2>&1; then
    kubectl create namespace "$ns"
  fi
done

