provider "azurerm" {
  features {}
}

locals {
  az_region_abbrv = var.az_region_abbr_map[var.az_region]
}

resource "random_string" "random" {
  length  = 16
  special = false
}

data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}