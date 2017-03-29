variable "do_token" { }

variable "droplet_name" { }
variable "droplet_region" { }
variable "droplet_size" { }

variable "private_key" { }
variable "public_key" { }

variable "client_id" { }
variable "client_secret" { }

variable "drone_secret" { }

provider  "digitalocean" {
  token = "${var.do_token}"
}

resource "template_file" "setup_drone" {
  template = "${file("${path.module}/setup_drone.sh.tpl")}"

  vars {
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    drone_secret = "${var.drone_secret}"
  }
}

resource "digitalocean_droplet" "drone-ci-server" {
  image = "docker"
  name = "${var.droplet_name}"
  region = "${var.droplet_region}"
  size = "${var.droplet_size}"
  private_networking = true

  ssh_keys = [
    "${digitalocean_ssh_key.drone-ci-server.fingerprint}"
  ]

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file("${var.private_key}")}"
    timeout = "2m"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "${template_file.setup_drone.rendered}"
    ]
  }
}

resource "digitalocean_floating_ip" "drone-ci-server" {
  droplet_id = "${digitalocean_droplet.drone-ci-server.id}"
  region = "${digitalocean_droplet.drone-ci-server.region}"
}

resource "digitalocean_ssh_key" "drone-ci-server" {
  name       = "drone-ci-server-ssh-key"
  public_key = "${file("${var.public_key}")}"
}
