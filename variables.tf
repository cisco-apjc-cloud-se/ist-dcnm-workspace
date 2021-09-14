### DCNM Variables

variable "dcnm_user" {
  type = string
}

variable "dcnm_password" {
  type = string
}

variable "dcnm_url" {
  type = string
}

variable "dcnm_fabric" {
  type = string
}

variable "switches" {
  type = list(string)
}

variable "vrfs" {
  type = map(object({
    name = string
    description = string
    vni_id = number
    vlan_id = number
    deploy = bool
    attached_switches = list(string)
  }))
}

variable "networks" {
  type = map(object({
    name = string
    description = string
    vrf_name = string
    ip_subnet = string
    vni_id = number
    vlan_id = number
    deploy = bool
    attached_switches = list(string)
  }))
}
