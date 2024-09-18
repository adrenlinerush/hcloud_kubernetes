resource "hcloud_network" "private_network" {
  name     = "k3s"
  ip_range = "10.0.1.0/24"
}

resource "hcloud_network_subnet" "private_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.private_network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_network_route" "bastion_internet_proxy" {
  network_id   = hcloud_network.private_network.id
  destination = "0.0.0.0/0"
  gateway     = "10.0.1.3"
}



