resource "azurerm_resource_group" "rgautomation" {
  name     = "${var.automation_rg_name}-${local.az_region_abbrv}"
  location = var.az_region
}