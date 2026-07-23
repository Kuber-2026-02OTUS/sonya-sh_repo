#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${ROOT_DIR}/ansible/inventory.ini"

nodes_json="$(terraform -chdir="${ROOT_DIR}/terraform" output -json nodes)"

control_plane="$(jq -r 'to_entries[] | select(.value.role == "control-plane") | .key' <<<"${nodes_json}" | head -n1)"

{
  echo "[control_plane]"
  jq -r 'to_entries[] | select(.value.role == "control-plane") | "\(.key) ansible_host=\(.value.external_ip) private_ip=\(.value.internal_ip)"' <<<"${nodes_json}"
  echo
  echo "[workers]"
  jq -r 'to_entries[] | select(.value.role == "worker") | "\(.key) ansible_host=\(.value.external_ip) private_ip=\(.value.internal_ip)"' <<<"${nodes_json}"
  echo
  echo "[kubeadm_cluster:children]"
  echo "control_plane"
  echo "workers"
  echo
  echo "[kubeadm_cluster:vars]"
  echo "ansible_user=ubuntu"
  echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
  echo "control_plane_host=${control_plane}"
} > "${OUT}"

echo "Inventory written to ${OUT}"
