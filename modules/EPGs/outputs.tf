output "tenant-dn" {
value = aci_tenant.TF_tenant.id
}

output "app-profile" {
value = aci_application_profile.TF_AP.id
}
