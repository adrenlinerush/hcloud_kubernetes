resource "hetznerdns_zone" "dns_zone" {
    name = var.dns_name
    ttl = 60
}

resource "hetznerdns_record" "k8s" {
    zone_id = hetznerdns_zone.dns_zone.id
    name = "*.k8s"
    value = hcloud_server.k3s_bastion.ipv4_address
    type = "A"
    ttl = 60
}
