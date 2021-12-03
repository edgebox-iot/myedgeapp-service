packer {
  required_plugins {
    digitalocean = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/digitalocean"
    }
  }
}

source "digitalocean" "ubuntu" {
  api_token = "${var.digitalocean_api_token}"
  image = "ubuntu-20-04-x64"
  region =  "fra1"
  size =  "s-1vcpu-1gb"
  ssh_username = "root"
  ssh_password = "${var.system_pw}"
  snapshot_name = "myedgeapp-cloud-001-{{timestamp}}"
}

build {
  sources = [
    "source.digitalocean.ubuntu",
  ]

  provisioner "shell" {
    environment_vars = [
      "IS_BOOTNODE=True",
      "SYSTEM_PW=${var.system_pw}",
      "PREFIX=${var.network_prefix}",
      "BOOTNODE_IP=${var.bootnode_ip}",
      "BOOTNODE_TOKEN=${var.bootnode_token}",
    ]
    scripts = [
      "scripts/setup.sh",
    ]
  }

  provisioner "shell" {    
    inline = ["echo '${var.system_pw}' | passwd --stdin root"]  
  }
}