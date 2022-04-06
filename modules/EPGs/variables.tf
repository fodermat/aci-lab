variable "apic_url" {
default = "https://10.50.28.136"
}
variable "apic_username" {
default = "apic#LOCAL\\fodermat"
}
variable "apic_password" {
default = "C1sc0123!"
}

variable "tenant" {
default = "TF_FODERMAT"
}

variable "vrf" {
default = "my-main-vrf"
}

variable "app_profile" {
default = "my-3Tier-App"
}

variable "bridge_domains" {
  type = map
  default = {
    aci_bd_app = {
      bd_name          = "APP_BD"
      bd_alias         = "APP_BD"
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
      subnet           = "10.10.30.254/24"
      subnet_alias     = "DB_Subnet"
    }
  }
}

variable "epgs" {
  type = map
  default = {
    aci_epg_app = {
        epg_name = "APP_EPG",
        bd = "aci_bd_app",
            },
    aci_epg_web = {
        epg_name = "WEB_EPG",
        bd   = "aci_bd_web",
      }
    aci_epg_DB = {
        epg_name = "DB_EPG",
        bd   = "aci_bd_db",
      }  
  }
}
