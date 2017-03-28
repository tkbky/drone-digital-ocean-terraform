output "ip" {
  value = "${digitalocean_floating_ip.drone-ci-server.ip_address}"
}
