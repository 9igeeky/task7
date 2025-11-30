packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
    openstack = {
      version = "~> 1"
      source  = "github.com/hashicorp/openstack"
    }
  }
}

variable "image_tag" {
    type = string
}
variable "sec_groups" {
    type = list(string)
}
variable "networks" {
    type = list(string)
}
source "openstack" "ubuntu-nginx-flask" {
    source_image_filter {
        filters {
            name = "ubuntu-24-202508151311.gitfaa03fa8"
        }
        most_recent = true
    }
    availability_zone = "GZ1"
    flavor  = "STD2-1-1"
    ssh_username = "ubuntu"
    security_groups = var.sec_groups
    volume_size = 10
    config_drive = "true"
    use_blockstorage_volume = "true"
    volume_type = "ceph-hdd"
    networks = var.networks



    image_name = "ubuntu-nginx-flask-${var.image_tag}"
}

build {
  sources = ["source.openstack.ubuntu-nginx-flask"]

  provisioner "ansible" {
    playbook_file   = "../site.yml"
    extra_arguments = [
      "-vvv"
    ]
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_RETRIES=5"
    ]
    user = "ubuntu"
  }
}