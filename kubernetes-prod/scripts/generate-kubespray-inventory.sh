#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${ROOT_DIR}/kubespray/inventory/mycluster/hosts.yaml"

nodes_json="$(terraform -chdir="${ROOT_DIR}/terraform" output -json nodes)"

{
  echo "all:"
  echo "  hosts:"
  jq -r '
    to_entries[]
    | "    \(.key):\n      ansible_host: \(.value.external_ip)\n      ip: \(.value.internal_ip)\n      access_ip: \(.value.internal_ip)"
  ' <<<"${nodes_json}"
  echo "  children:"
  echo "    kube_control_plane:"
  echo "      hosts:"
  jq -r 'to_entries[] | select(.value.role == "control-plane") | "        \(.key):"' <<<"${nodes_json}"
  echo "    kube_node:"
  echo "      hosts:"
  jq -r 'to_entries[] | "        \(.key):"' <<<"${nodes_json}"
  echo "    etcd:"
  echo "      hosts:"
  jq -r 'to_entries[] | select(.value.role == "control-plane") | "        \(.key):"' <<<"${nodes_json}"
  echo "    k8s_cluster:"
  echo "      children:"
  echo "        kube_control_plane:"
  echo "        kube_node:"
  echo "    calico_rr:"
  echo "      hosts: {}"
  echo "  vars:"
  echo "    ansible_user: ubuntu"
  echo "    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'"
} > "${OUT}"

echo "Kubespray inventory written to ${OUT}"
