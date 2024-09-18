data "template_file" "worker_init" {
  template = "${file("${path.module}/templates/worker_node_cloud_init.tpl")}"

  vars = {
   k3s_cluster_token = "${var.k3s_cluster_token}"
  }
}

resource "hcloud_server" "k3s_wn_n" {
  count = var.number_worker_nodes

  name = "k3s-wn-${count.index}"
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
  user_data = "${data.template_file.worker_init.rendered}"
  ssh_keys = [ var.ssh_key_name ]
  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_server.k3s_cp_1, hcloud_ssh_key.default]

}
