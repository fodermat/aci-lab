terraform {
    required_providers {
        aci = {
            source = "ciscodevnet/aci"
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

module "epgs" {
   source = "github.com/fodermat/aci-lab/modules/EPGs"
}

resource "aci_filter" "tf_icmp" {
   tenant_dn = module.epgs.tenant-dn
   name      = "tf_icmp"
 }
 
resource "aci_filter_entry" "icmp" {
   name        = "icmp"
   filter_dn   = aci_filter.tf_icmp.id
   ether_t     = "ip"
   prot        = "icmp"
   stateful    = "yes"
 }
 
resource "aci_filter" "tf_http" {
   tenant_dn =  module.epgs.tenant-dn
   name      = "tf_http"
 }
 
resource "aci_filter_entry" "http" {
   name        = "http"
   filter_dn   = aci_filter.tf_http.id
   ether_t     = "ip"
   prot        = "tcp"
   d_from_port = "80"
   d_to_port   = "80"
   stateful    = "yes"
 } 
 
 resource "aci_filter" "tf_mysql" {
   tenant_dn = module.epgs.tenant-dn
   name      = "tf_mysql"
 }
 
resource "aci_filter_entry" "mysql" {
   name        = "mysql"
   filter_dn   = aci_filter.tf_mysql.id
   ether_t     = "ip"
   prot        = "tcp"
   d_from_port = "3306"
   d_to_port   = "3306"
   stateful    = "yes"
 } 

resource "aci_filter" "tf_ssh" {
   tenant_dn = module.epgs.tenant-dn
   name      = "tf_ssh"
 }
 
resource "aci_filter_entry" "ssh" {
   name        = "ssh"
   filter_dn   = aci_filter.tf_ssh.id
   ether_t     = "ip"
   prot        = "tcp"
   d_from_port = "22"
   d_to_port   = "22"
   stateful    = "yes"
 } 

resource "aci_contract_subject" "tf_web_subj" {
   contract_dn                  = aci_contract.tf_app-web_con.id
   name                         = "tf_web_subj"
   relation_vz_rs_subj_filt_att = [aci_filter.tf_icmp.id, aci_filter.tf_http.id,aci_filter.tf_ssh.id]
 }
 
resource "aci_contract" "tf_app-web_con" {
  tenant_dn                 = module.epgs.tenant-dn
  name                        = "TF_app-to-web_con"
 }

resource "aci_contract_subject" "tf_app_subj" {
   contract_dn                  = aci_contract.tf_app-db_con.id
   name                         = "tf_app_subj"
   relation_vz_rs_subj_filt_att = [aci_filter.tf_icmp.id, aci_filter.tf_mysql.id]
 }
 
 resource "aci_contract" "tf_app-db_con" {
  tenant_dn                 = module.epgs.tenant-dn
  name                        = "TF_app-to-db_con"
 }
 
 resource "aci_contract_subject" "tf_db_subj" {
   contract_dn                  = aci_contract.tf_db-app_con.id
   name                         = "tf_db_subj"
   relation_vz_rs_subj_filt_att = [aci_filter.tf_icmp.id, aci_filter.tf_ssh.id]
 }
 
 resource "aci_contract" "tf_db-app_con" {
  tenant_dn                 = module.epgs.tenant-dn
  name                        = "TF_db-to-app_con"
 }
     
 resource "aci_application_epg" "Web_EPG" {
    name                   = "WEB_EPG"
    application_profile_dn = module.epgs.app-profile
    relation_fv_rs_prov    = [aci_contract.tf_app-web_con.id]
}

resource "aci_application_epg" "App_EPG" {
    name                   = "APP_EPG"
    application_profile_dn = module.epgs.app-profile
    relation_fv_rs_cons    = [aci_contract.tf_app-web_con.id, aci_contract.tf_app-db_con.id]
}

resource "aci_application_epg" "backend_EPG" {
    name                   = "DB_EPG"
    application_profile_dn = module.epgs.app-profile
    relation_fv_rs_prov    = [aci_contract.tf_app-db_con.id]
    relation_fv_rs_cons    = [aci_contract.tf_db-app_con.id
}
