data "yandex_compute_image" "ubuntu" {
  family = var.ubuntu_image_family
}

locals {
  kubeadm_nodes = {
    kubeadm-cp-1 = {
      role   = "control-plane"
      cores  = 2
      memory = 4
      disk   = 30
    }
    kubeadm-worker-1 = {
      role   = "worker"
      cores  = 2
      memory = 4
      disk   = 30
    }
    kubeadm-worker-2 = {
      role   = "worker"
      cores  = 2
      memory = 4
      disk   = 30
    }
    kubeadm-worker-3 = {
      role   = "worker"
      cores  = 2
      memory = 4
      disk   = 30
    }
  }

  kubespray_nodes = {
    ks-cp-1 = {
      role   = "control-plane"
      cores  = 2
      memory = 4
      disk   = 40
    }
    ks-cp-2 = {
      role   = "control-plane"
      cores  = 2
      memory = 4
      disk   = 40
    }
    ks-cp-3 = {
      role   = "control-plane"
      cores  = 2
      memory = 4
      disk   = 40
    }
    ks-worker-1 = {
      role   = "worker"
      cores  = 2
      memory = 4
      disk   = 40
    }
    ks-worker-2 = {
      role   = "worker"
      cores  = 2
      memory = 4
      disk   = 40
    }
  }

  nodes = var.cluster_profile == "kubeadm" ? local.kubeadm_nodes : local.kubespray_nodes
}

resource "yandex_vpc_network" "this" {
  name = "dz14-${var.cluster_profile}-net"
}

resource "yandex_vpc_subnet" "this" {
  name           = "dz14-${var.cluster_profile}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.subnet_cidr]
}

resource "yandex_vpc_security_group" "k8s" {
  name       = "dz14-${var.cluster_profile}-sg"
  network_id = yandex_vpc_network.this.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API"
    port           = 6443
    v4_cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    protocol       = "ANY"
    description    = "Node to node traffic inside lab subnet"
    v4_cidr_blocks = [var.subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Outbound Internet access"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "nodes" {
  for_each = local.nodes

  name        = each.key
  hostname    = each.key
  platform_id = "standard-v3"
  zone        = var.zone

  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.disk
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.this.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s.id]
  }

  metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${file(pathexpand(var.public_key_path))}"
  }
}
