#!/bin/bash


helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring -f monitoring-values.yaml

