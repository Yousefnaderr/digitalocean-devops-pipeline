#!/usr/bin/env bash
# ----------------------------------------------------
# Script: install-cert-manager.sh
# Purpose: Install cert-manager via Helm and configure Let's Encrypt ClusterIssuers
# Author: Youssef
# ----------------------------------------------------

set -e

NAMESPACE="cert-manager"

echo "Starting cert-manager installation..."

# Step 1: Create namespace if it doesn't exist
if ! kubectl get ns $NAMESPACE >/dev/null 2>&1; then
  kubectl create ns $NAMESPACE
fi

# Step 2: Add and update Helm repo
helm repo add jetstack https://charts.jetstack.io >/dev/null 2>&1
helm repo update >/dev/null 2>&1

# Step 3: Install/Upgrade cert-manager via Helm
echo "📦 Installing cert-manager using Helm..."
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace $NAMESPACE \
  --set installCRDs=true

# Step 4: Wait for cert-manager pods to be ready
echo "⏳ Waiting for cert-manager pods to become ready..."
kubectl wait --for=condition=Ready pods -l app.kubernetes.io/instance=cert-manager -n $NAMESPACE --timeout=180s

# Step 5: Apply ClusterIssuers (Staging + Production)
echo "🧾 Applying ClusterIssuers..."

# --- Let's Encrypt Staging ---
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    email: youssefnaderr@swipebay.tech
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-staging-secret
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

# --- Let's Encrypt Production ---
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
spec:
  acme:
    email: youssefnaderr@swipebay.tech
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod-secret
    solvers:
    - http01:
        ingress:
          class: nginx
EOF


kubectl get clusterissuers

echo "cert-manager installation and configuration completed successfully!"

