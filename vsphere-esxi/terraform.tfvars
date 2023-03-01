# ============================ #
# VMware vSphere configuration #
# ============================ #

# VMware vCenter IP/FQDN
vsphere-vcenter = "vcenter.paulnetwork.local"

# VMware vSphere username used to deploy the infrastructure
vsphere-user = "terraform@paulnetwork.local"

# VMware vSphere password used to deploy the infrastructure
vsphere-password = "143FF2Eof$34039Grlafds"

# Skip the verification of the vCenter SSL certificate (true/false)
vsphere-unverified-ssl = "true"

# vSphere datacenter name where the infrastructure will be deployed
vsphere-datacenter = "PN-SuperMicro1"

# vSphere cluster name where the infrastructure will be deployed
vsphere-cluster = "PN-CLS"

# esxi used 
#esxi-name = "esxi.paulnetwork.local"

# vSphere Datastore used to deploy VMs 
vm-datastore = "DS1-SSD256"

# Linux virtual machine domain name
vm-domain = "paulnetwork.local"

