variable "cloud_id" {
  description = "Yandex Cloud cloud id"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder id"
  type        = string
}

variable "zone" {
  description = "Yandex Cloud availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "cluster_profile" {
  description = "VM set to create: kubeadm or kubespray"
  type        = string
  default     = "kubeadm"

  validation {
    condition     = contains(["kubeadm", "kubespray"], var.cluster_profile)
    error_message = "cluster_profile must be kubeadm or kubespray."
  }
}

variable "public_key_path" {
  description = "Path to public SSH key for ubuntu user"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH and Kubernetes API"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ubuntu_image_family" {
  description = "Ubuntu image family from Yandex Cloud marketplace"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "subnet_cidr" {
  description = "Subnet CIDR for lab VMs"
  type        = string
  default     = "10.14.0.0/24"
}
