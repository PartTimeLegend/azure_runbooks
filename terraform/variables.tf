variable "az_region" {
  type    = string
  default = "UK South"
}

variable "az_region_abbr_map" {
  type        = map(any)
  description = "Map is used to obtain 3 letter azure region abreviation for naming resources"
  default = {
    "Central US"             = "cus"
    "East US 2"              = "eus2"
    "East US"                = "eus"
    "North Central US"       = "ncus"
    "South Central US"       = "nsus"
    "West US 2"              = "wus2"
    "West Central US"        = "wcus"
    "West US,US DoD Central" = "wusd"
    "US DoD East"            = "usde"
    "US Gov. Arizona"        = "usga"
    "US Gov. Iowa"           = "usgi"
    "US Gov. Texas"          = "usgt"
    "US Gov. Virginia"       = "usgv"
    "US Sec East"            = "usse"
    "US Sec West"            = "ussw"
    "Canada Central"         = "cc"
    "Canada East"            = "ce"
    "Brazil South"           = "bs"
    "North Europe"           = "eun"
    "West Europe"            = "euw"
    "UK South"               = "uks"
    "UK West"                = "ukw"
    "Germany North"          = "gn"
    "Germany West Central"   = "gwc"
    "Switzerland North"      = "sn"
    "Switzerland West"       = "sw"
    "Norway West"            = "nw"
    "Norway East"            = "ne"
    "East Asia"              = "ea"
    "Southeast Asia"         = "sa"
    "Australia Central"      = "ac"
    "Australia Central 2"    = "ac2"
    "Australia East"         = "ae"
    "Australia Southeast"    = "as"
    "China East"             = "ce"
    "China North"            = "cn"
    "China East 2"           = "ce2"
    "China North 2"          = "cn2"
    "Central India"          = "ci"
    "South India"            = "si"
    "West India"             = "wi"
    "Japan East"             = "je"
    "Japan West"             = "jw"
    "Korea Central"          = "kc"
    "Korea South"            = "ks"
    "South Africa North"     = "san"
    "South Africa West"      = "saw"
    "UAE Central"            = "uc"
    "UAE North"              = "un"
  }
}

variable "automation_rg_name" {
  type    = string
  default = "rg-automation"
}

variable "automation_account_name" {
  type    = string
  default = "aa-automation"
}

variable "cert_end_date" {
  type    = string
  default = "2021-06-14T15:29:26Z"
}