terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mel-ciscolabs-com"
    workspaces {
      name = "ist-dcnm-workspace"
    }
  }
  required_providers {
    dcnm = {
      source = "CiscoDevNet/dcnm"
      # version = "0.0.5"
    }
  }
}

## If using DCNM to assign VNIs use -parallelism=1

provider "dcnm" {
  username = var.dcnm_user
  password = var.dcnm_password
  url      = var.dcnm_url
  insecure = true
}

## Read Switch Inventory ##
data "dcnm_inventory" "switches" {
  # for_each = transpose(var.dc_switches)
  for_each = toset(var.switches)

  fabric_name = var.dcnm_fabric
  switch_name = each.key
}

## Build Local Dictionaries
# - serial_numbers: Switch Name -> Serial Number
# - merged: cluster_interfaces with added serial_number

locals {
  serial_numbers = {
      for switch in data.dcnm_inventory.switches :
          switch.switch_name => switch.serial_number
  }
  // merged_cluster_interfaces = {
  //   for switch in var.cluster_interfaces :
  //       switch.name => {
  //         name = switch.name
  //         attach = switch.attach
  //         switch_ports = switch.switch_ports
  //         serial_number = lookup(local.serial_numbers, switch.name)
  //       }
  // }
}

## Build New VRFs ###
resource "dcnm_vrf" "first" {
  for_each = var.vrfs

  fabric_name             = var.dcnm_fabric
  name                    = each.value.name
  vlan_id                 = each.value.vlan_id
  segment_id              = each.value.vni_id
  vlan_name               = each.value.name
  description             = each.value.description
  intf_description        = each.value.name
  // tag                     = "12345"
  max_bgp_path            = 2
  max_ibgp_path           = 2
  // trm_enable              = false
  // rp_external_flag        = true
  // rp_address              = "1.2.3.4"
  // loopback_id             = 15
  // mutlicast_address       = "10.0.0.2"
  // mutlicast_group         = "224.0.0.1/4"
  // ipv6_link_local_flag    = "true"
  // trm_bgw_msite_flag      = true
  advertise_host_route    = true
  // advertise_default_route = true
  // static_default_route    = false
  deploy                  = each.value.deploy

  dynamic "attachments" {
    for_each = toset(each.value.attached_switches)
    content {
      serial_number = lookup(local.serial_numbers, attachments.key)
      vlan_id = each.value.vlan_id
      attach = true
      // loopback_id   = 70
      // loopback_ipv4 = "1.2.3.4"
    }
  }
}

## Build New L3 Networks ##

resource "dcnm_network" "networks" {
  for_each = var.networks

  fabric_name     = var.dcnm_fabric
  name            = each.value.name
  network_id      = each.value.vni_id
  display_name    = each.value.name
  description     = each.value.description
  vrf_name        = each.value.vrf_name
  vlan_id         = each.value.vlan_id
  vlan_name       = each.value.name
  ipv4_gateway    = each.value.ip_subnet
  # ipv6_gateway    = "2001:db8::1/64"
  # mtu             = 1500
  # secondary_gw_1  = "192.0.3.1/24"
  # secondary_gw_2  = "192.0.3.1/24"
  # arp_supp_flag   = true
  # ir_enable_flag  = false
  # mcast_group     = "239.1.2.2"
  # dhcp_1          = "1.2.3.4"
  # dhcp_2          = "1.2.3.5"
  # dhcp_vrf        = "VRF1012"
  # loopback_id     = 100
  # tag             = "1400"
  # rt_both_flag    = true
  # trm_enable_flag = true
  l3_gateway_flag = true
  deploy          = each.value.deploy

  dynamic "attachments" {
    # for_each = each.value.attachments
    for_each = toset(each.value.attached_switches)
    content {
      serial_number = lookup(local.serial_numbers, attachments.key)
      vlan_id       = each.value.vlan_id
      attach        = true
      // switch_ports  = attachments.value["switch_ports"]
    }
  }
}
