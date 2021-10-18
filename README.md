# ist-dcnm-workspace
Intersight Service for Terraform Demo with Nexus Dashboard Fabric Controller (a.k.a DCNM)- Common Overlay Configuration

This includes configuring
- VRFs
- Networks
- vPC Interfaces

Options to extend:
- IPAM integration to add/update subnets, VLAN IDs

Inputs
- dcnm_user, dcnm_password and dcnm_url in workspace variables
- demo.auto.tfvars defines target fabric, switches, VRFs and networks.
