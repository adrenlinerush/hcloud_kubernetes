data "template_file" "bastion_init" {
  template = "${file("${path.module}/templates/bastion_cloud_init.tpl")}"

  vars = {
   id_rsa = file("~/.ssh/id_rsa")
   domain_name = "${var.dns_name}"
  }
}

output "bastion_cloud_init" {
  value = "${data.template_file.bastion_init.rendered}"
}

resource "hcloud_server" "k3s_bastion" {
  name = "k3s-bastion"
  image       = "debian-12"
  server_type = "cax11"
  location    = "nbg1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  network {
    network_id = hcloud_network.private_network.id
    ip = "10.0.1.3"
  }
  user_data = "${data.template_file.bastion_init.rendered}"
  ssh_keys = [ var.ssh_key_name ]
  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_ssh_key.default]
}
