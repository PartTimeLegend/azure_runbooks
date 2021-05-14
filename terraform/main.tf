provider "azurerm" {
  features {}
}
locals {
  az_region_abbrv = var.az_region_abbr_map[var.az_region]
}

resource "azurerm_resource_group" "rgautomation" {
  name     = "${var.automation_rg_name}-${local.az_region_abbrv}"
  location = var.az_region
}

resource "azurerm_automation_account" "automation_account" {
  name                = "${var.automation_account_name}-${local.az_region_abbrv}"
  location            = azurerm_resource_group.rgautomation.location
  resource_group_name = azurerm_resource_group.rgautomation.name
  sku_name            = "Basic"
  depends_on = [
    azurerm_resource_group.rgautomation
  ]
}

data "local_file" "runbook_powershell" {
  filename = "../Cleanup.ps1"
}

resource "azurerm_automation_runbook" "automation_runbook" {
  name                    = "${var.automation_runbook_name}-${local.az_region_abbrv}"
  location                = azurerm_automation_account.automation_account.location
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Removes Resources with tmp in name"
  runbook_type            = "PowerShell"
  content                 = data.local_file.runbook_powershell.content
  depends_on = [
    azurerm_resource_group.rgautomation,
    azurerm_automation_account.automation_account,
    data.local_file.runbook_powershell
  ]
  publish_content_link {
    uri = "https://www.microsoft.com" # Placeholder as Azure is dumb
  }
}

output "location" {
  value = local.az_region_abbrv
}

output "resource_group_name" {
  value = azurerm_resource_group.rgautomation.name
}

output "automation_account_name" {
  value = azurerm_automation_account.automation_account.name
}

output "runbook_name" {
  value = azurerm_automation_runbook.automation_runbook.name
}