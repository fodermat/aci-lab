variable "apic_url" {}
variable "apic_username" {}
variable "apic_password" {}
variable "tenant" {}
variable "vrf" {}
variable "app_profile" {}

variable "bridge_domains" {
  type = map
  default = {
    aci_bd_app = {
      bd_name          = "front_BD"
      bd_alias         = "front_BD"
      subnet           = "20.20.20.254/24"
      subnet_alias     = "front_Subnet"
    },
    aci_bd_web = {
      bd_name          = "WEB_BD"
      bd_alias         = "WEB_BD"
      subnet           = "10.10.10.254/24"
      subnet_alias     = "Web_Subnet"
    },
    aci_bd_db = {
      bd_name          = "DB_BD"
      bd_alias         = "DB_BD"
      subnet           = "30.30.30.254/24"
      subnet_alias     = "DB_Subnet"
    }
  }
}

variable "epgs" {
  type = map
  default = {
    aci_epg_app = {
        epg_name = "front_EPG",
        bd = "aci_bd_app"
            },
    aci_epg_web = {
        epg_name = "WEB_EPG",
        bd   = "aci_bd_web"
      }
    aci_epg_DB = {
        epg_name = "DB_EPG",
        bd   = "aci_bd_db"
      }  
  }
}

