cluster_profile = "kubeadm"
zone            = "ru-central1-a"
subnet_cidr     = "10.14.0.0/24"

# Fill from `yc config get cloud-id` and `yc config get folder-id`.
cloud_id  = "b1g7j8v98kpe5nlks12v"
folder_id = "b1gcfeql1qok869p6jl7"

# Better replace 0.0.0.0/0 with your current public IP /32.
ssh_cidr_blocks = ["0.0.0.0/0"]
public_key_path = "~/.ssh/id_ed25519.pub"
