output "nodes" {
  description = "VM addresses for Ansible inventory generation"
  value = {
    for name, vm in yandex_compute_instance.nodes : name => {
      role        = local.nodes[name].role
      internal_ip = vm.network_interface[0].ip_address
      external_ip = vm.network_interface[0].nat_ip_address
    }
  }
}

output "ssh_examples" {
  value = [
    for name, vm in yandex_compute_instance.nodes :
    "ssh ubuntu@${vm.network_interface[0].nat_ip_address} # ${name}"
  ]
}
