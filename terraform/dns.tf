locals {
  split_domain = split(".", var.dns_name)
}

resource "hetznerdns_zone" "dns_zone" {
    name = join(".", slice(local.split_domain, 1, length(local.split_domain)))
    ttl = 60
}

resource "hetznerdns_record" "k8s" {
    zone_id = hetznerdns_zone.dns_zone.id
    name = "*.${local.split_domain[0]}"
    value = hcloud_server.k3s_bastion.ipv4_address
    type = "A"
    ttl = 60
}
