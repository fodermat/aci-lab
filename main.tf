terraform {
    required_providers {
        aci = {
            source = "ciscodevnet/aci"
            version = "1.2.0"
            }
        }   
}

provider "aci" {
  username = "${var.apic_username}"
  password = "${var.apic_password}"
  #private_key = "/Users/fodermat/Terraform/fodermat-aci.key"
  #cert_name = "/Users/fodermat/Terraform/fodermat-aci.crt"
  url      = "${var.apic_url}"
  insecure = true
}



module "contracts" {
    source = "./modules/contracts"
}

module "epgs" {
    source = "./modules/epgs"
}
