resource "hcloud_load_balancer" "load_balancer" {
  name               = "k3s-lb"
  load_balancer_type = "lb11"
  location           = "nbg1"
  delete_protection  = false

  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_server.k3s_cp_1]
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "http"

  depends_on = [hcloud_load_balancer.load_balancer]
}

resource "hcloud_load_balancer_network" "lb_network" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  network_id       = hcloud_network.private_network.id

  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_load_balancer.load_balancer]
}

resource "hcloud_load_balancer_target" "load_balancer_target_cp_1" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = hcloud_server.k3s_cp_1.id
  use_private_ip   = true

  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_load_balancer_network.lb_network, hcloud_server.k3s_cp_1]
}

resource "hcloud_load_balancer_target" "load_balancer_target_cp_n" {
  for_each = { for idx, server in hcloud_server.k3s_cp_n : idx => server }
  
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = each.value.id
  use_private_ip   = true

  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_load_balancer_network.lb_network, hcloud_server.k3s_cp_n]
}

resource "hcloud_load_balancer_target" "load_balancer_target_wn_n" {
  for_each = { for idx, server in hcloud_server.k3s_wn_n : idx => server }
  
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = each.value.id
  use_private_ip   = true

  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_load_balancer_network.lb_network, hcloud_server.k3s_wn_n]
}
