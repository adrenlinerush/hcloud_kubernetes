variable "ssh_key_name" {
  type = string
}
variable "k3s_cluster_token" {
  type = string
}
variable "additional_cp_nodes" {
  type = number
  default = 2
}
variable "number_worker_nodes" {
  type = number
  default = 3
}
