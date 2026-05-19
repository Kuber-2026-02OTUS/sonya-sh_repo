#!/usr/bin/env bash
set -euo pipefail

rm -f kubernetes-security/cd-kubeconfig

CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
CLUSTER_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CA_FILE=$(kubectl config view --raw --minify -o jsonpath='{.clusters[0].cluster.certificate-authority}')
TOKEN=$(cat kubernetes-security/token)

kubectl config --kubeconfig=kubernetes-security/cd-kubeconfig set-cluster "$CLUSTER_NAME" \
  --server="$CLUSTER_SERVER" \
  --certificate-authority="$CA_FILE" \
  --embed-certs=true

kubectl config --kubeconfig=kubernetes-security/cd-kubeconfig set-credentials cd \
  --token="$TOKEN"

kubectl config --kubeconfig=kubernetes-security/cd-kubeconfig set-context cd \
  --cluster="$CLUSTER_NAME" \
  --user=cd \
  --namespace=homework

kubectl config --kubeconfig=kubernetes-security/cd-kubeconfig use-context cd
