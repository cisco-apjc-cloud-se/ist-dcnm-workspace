# Intersight Service for Terraform Demo with Nexus Dashboard Fabric Controller (a.k.a DCNM)- Common Overlay Configuration

## Overview
This use focuses on the basic overlay configuration for common Day 2 DC networking tasks.

This use case includes configuring:
- VRFs
- Networks
- vPC Interfaces

## Requirements
The Infrastructure-as-Code environment will require the following:
* GitHub Repository for Terraform plans, modules and variables as HCL or JSON files
* Terraform Cloud for Business account with a workspace associated to the GitHub repository above
* Cisco Intersight (SaaS) platform account with sufficient Advantage licensing
* An Intersight Assist appliance VM connected to the Intersight account above
* A Cisco Nexus Dashboard Fabric Controller (NDFC), formerly known as Data Center Network Manager (DCNM) instance and existng DC fabric to automate.

## Assumptions
Thise use case makes the following assumptions:
* An existing Nexus 9000 switch based VXLAN fabric has already been deployed and that it is actively managed through a DCNM instance.
* The DCNM server is accessible by HTTPS from the Intersight Assist VM.
* Suitable IP subnets (at least /29) are available to be assigned to each new L3 network.
* Suitable VLAN IDs are available to be assigned to each new L3 network.
* The following variables are defined within the Terraform Workspace.  These variables should not be configured within the public GitHub repository files.
  * DCNM account username (dcnm_user)
  * DCNM account password (dcnm_password)
  *	DCNM URL (dcnm_url)

## Link to Github Repositories
https://github.com/cisco-apjc-cloud-se/ist-dcnm-workspace

## Steps to Deploy Use Case
1.	In GitHub, create a new, or clone the example GitHub repository(s)
2.	Customize the examples Terraform files & input variables as required
3.	In Intersight, configure a Terraform Cloud target with suitable user account and token
4.	In Intersight, configure a Terraform Agent target with suitable managed host URLs/IPs.  This list of managed hosts must include the IP addresses for the DCNM server as well as access to common GitHub domains in order to download hosted Terraform providers.  This will create a Terraform Cloud Agent pool and register this to Terraform Cloud.
5.	In Terraform Cloud for Business, create a new Terraform Workspace and associate to the GitHub repository.
6.	In Terraform Cloud for Business, configure the workspace to the use the Terraform Agent pool configured from Intersight.
7.	In Terraform Cloud for Business, configure the necessary user account variables for the DCNM servers.

## Execute Deployment
In Terraform Cloud for Business, queue a new plan to trigger the initial deployment.  Any future changes to pushed to the GitHub repository will automatically trigger a new plan deployment.

## Results
If successfully executed, the Terraform plan will result in the following configuration:

* New VRF(s)
  * Name
  * VXLAN VNI ID
  * Layer 2 VLAN ID (for Symmetric IRB)
* New Layer 3 VXLAN networks, as defined in the “dc_networks” JSON object, within the existing VRF, each with the following configuration:
  * Name
  * Anycast Gateway IPv4 Address/Mask
  * VXLAN VNI ID
  * Layer 2 VLAN ID

## Expected Day 2 Changes
Changes to the variables defined in the input variable files will result in dynamic, stateful update to DCNM. For example,
