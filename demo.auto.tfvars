dcnm_fabric = "DC3"

### FABRIC INVENTORY ###
switches = [
  "DC3-LEAF-1",
  "DC3-LEAF-2",
  "DC3-BORDER-1",
  "DC3-BORDER-2"
]

### VRFS ###
vrfs = {
  TFCB-VRF-1 = {
    name = "TFCB-VRF-1"
    description = "VRF Created by Terraform Plan #1"
    vni_id = 33001
    vlan_id = 3001
    deploy = true
    attached_switches = [
      "DC3-LEAF-1",
      "DC3-LEAF-2",
      "DC3-BORDER-1",
      "DC3-BORDER-2"
    ]
  }
  TFCB-VRF-2 = {
    name = "TFCB-VRF-2"
    description = "VRF Created by Terraform Plan #2"
    vni_id = 33002
    vlan_id = 3002
    deploy = true
    attached_switches = [
      "DC3-LEAF-1",
      "DC3-LEAF-2",
      "DC3-BORDER-1",
      "DC3-BORDER-2"
    ]
  }
}

### INTERFACES ###

### NETWORKS ###
networks = {
  TFCB-NET-1 = {
    name = "TFCB-NET-1"
    description = "Terraform Intersight Demo Network #1"
    vrf_name = "TFCB-VRF-1"
    ip_subnet = "192.168.101.1/24"
    vni_id = 33101
    vlan_id = 3101
    deploy = true
    attached_switches = [
      "DC3-LEAF-1",
      "DC3-LEAF-2",
      "DC3-BORDER-1",
      "DC3-BORDER-2"
    ]
  }
  TFCB-NET-2 = {
    name = "TFCB-NET-2"
    description = "Terraform Intersight Demo Network #2"
    vrf_name = "TFCB-VRF-1"
    ip_subnet = "192.168.102.1/24"
    vni_id = 33102
    vlan_id = 3102
    deploy = true
    attached_switches = [
      "DC3-LEAF-1",
      "DC3-LEAF-2",
      "DC3-BORDER-1",
      "DC3-BORDER-2"
    ]
  }
}
