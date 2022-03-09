resource "aci_tenant" "TF_tenant" {
  name = "${var.tenant}"
  description =   "From Terraform"
}

resource "aci_vrf" "TF_VRF" {
  tenant_dn              = aci_tenant.TF_tenant.id
  name                   = "${var.vrf}"
  description            = "From Terraform"
}

resource "aci_application_profile" "TF_AP" {
  tenant_dn = aci_tenant.TF_tenant.id
  name       = "${var.app_profile}"
  description =   "From Terraform"

}

resource "aci_bridge_domain" "TF_BD" {
   for_each = var.bridge_domains
    tenant_dn   = aci_tenant.TF_tenant.id
    name        = each.value.bd_name
    name_alias  = each.value.bd_alias
}

resource "aci_subnet" "TF_Subnet" {
    for_each = var.bridge_domains
    parent_dn = aci_bridge_domain.TF_BD[each.key].id
    description = "From Terraform"
    ip = each.value.subnet 
    name_alias = each.value.subnet_alias
}
  
resource "aci_application_epg" "TF_EPG" {
    for_each = var.epgs
    application_profile_dn  = aci_application_profile.TF_AP.id
    description =   "From Terraform"
    name = each.value.epg_name
    relation_fv_rs_bd = aci_bridge_domain.TF_BD[each.value.bd].id
}
