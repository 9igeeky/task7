variable "image_id" {
    type = string
}
variable "node_count" {
    type = number
}
variable "flavor_name" {
    type = string
}
variable "key_pair_name" {
    type = string
}
variable "disk_size" {
    type = number
}
variable "sec_group" {
    type = list(string)
}
variable "network" {
    type = string
}
variable "dbtype" {
    type = string
}
variable "db_version" {
    type = string
}
#variable "db_user_password" {
#  type      = string
#  sensitive = true
#}
variable "db-instance-flavor" {
  type    = string
  default = "STD3-4-8-50"
}
data "vkcs_compute_flavor" "db" {
  name = var.db-instance-flavor
}
resource "vkcs_networking_network" "db" {
  name           = "db-net"
  admin_state_up = true
}
resource "vkcs_networking_subnet" "db-subnetwork" {
  name            = "db-subnet"
  network_id      = vkcs_networking_network.db.id
  cidr            = "10.100.0.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
  enable_dhcp = true
}
data "vkcs_networking_network" "extnet" {
  name = "internet"
}
resource "vkcs_networking_router" "db-router" {
  name                = "db-router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}
resource "vkcs_networking_router_interface" "db" {
  router_id = vkcs_networking_router.db-router.id
  subnet_id = vkcs_networking_subnet.db-subnetwork.id
}
resource "vkcs_db_instance" "db-instance" {
    name = "db-postgres-1"
    datastore {
        type = var.dbtype
        version = var.db_version
    }
    availability_zone = "GZ1"
    floating_ip_enabled = true
    flavor_id = data.vkcs_compute_flavor.db.id
    size = 8
    volume_type = "ceph-ssd"
    disk_autoexpand {
        autoexpand    = true
        max_disk_size = 100
    }
    network {
        uuid = vkcs_networking_network.db.id
    }
    depends_on = [
        vkcs_networking_router_interface.db
    ]
}
resource "vkcs_db_database" "db-database" {
  name        = "testdb"
  dbms_id = vkcs_db_instance.db-instance.id
  charset     = "utf8"
}
#resource "vkcs_db_user" "db-user" {
#  name        = "testuser"
#  password    = var.db_user_password
#  dbms_id = vkcs_db_instance.db-instance.id
#  databases   = [vkcs_db_database.db-database.name]
#}

resource "vkcs_compute_instance" "instance" {
    count = var.node_count
    name = "node-${count.index}"
    image_id = var.image_id
    flavor_name = var.flavor_name
    key_pair = var.key_pair_name
    config_drive = true
    security_group_ids = var.sec_group
    network {
        uuid = var.network
    } 
    block_device {
        uuid                  = var.image_id
        source_type           = "image"
        destination_type      = "volume"
        volume_type           = "ceph-hdd"
        volume_size           = var.disk_size
        boot_index            = 0
        delete_on_termination = true
  }
}