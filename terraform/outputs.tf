output "location" {
  value = local.az_region_abbrv
}

output "resource_group_name" {
  value = azurerm_resource_group.rgautomation.name
}

output "automation_account_name" {
  value = azurerm_automation_account.automation_account.name
}

output "service_principal" {
  value = azuread_service_principal.service_principal.display_name
}

output "tmp_runbook_name" {
  value = azurerm_automation_runbook.tmp_automation_runbook.name
}