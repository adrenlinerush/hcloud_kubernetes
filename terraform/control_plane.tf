data "template_file" "k3s_cp_1_init" {
  template = "${file("${path.module}/templates/control_plane_cloud_init.tpl")}"

  vars = {
   k3s_cluster_token = "${var.k3s_cluster_token}"
  }
}

resource "hcloud_server" "k3s_cp_1" {
  name        = "k3s-cp-1"
  image       = "debian-12"
  server_type = "cax11"
  location    = "nbg1"
  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }
  network {
    network_id = hcloud_network.private_network.id
    ip         = "10.0.1.2"
  }
  user_data = "${data.template_file.k3s_cp_1_init.rendered}"
  ssh_keys = [ var.ssh_key_name ]
  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_ssh_key.default, hcloud_server.k3s_bastion]
}

data "template_file" "k3s_cp_add_init" {
  template = "${file("${path.module}/templates/control_plane_cloud_init_add.tpl")}"

  vars = {
   k3s_cluster_token = "${var.k3s_cluster_token}"
  }
}

resource "hcloud_server" "k3s_cp_n" {
  count = var.additional_cp_nodes

  name = "k3s-cp-n${count.index}"
  image       = "debian-12"
  server_type = "cax11"
  location    = "nbg1"
  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }
  network {
    network_id = hcloud_network.private_network.id
  }
  user_data = "${data.template_file.k3s_cp_add_init.rendered}"
  ssh_keys = [ var.ssh_key_name ]
  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_server.k3s_cp_1, hcloud_ssh_key.default]

}
