data "local_file" "tmp_runbook_powershell" {
  filename = "../RemoveTmpResources.ps1"
}

resource "azurerm_automation_runbook" "tmp_automation_runbook" {
  name                    = "rb-remove-tmp-resources-${local.az_region_abbrv}"
  location                = azurerm_automation_account.automation_account.location
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Removes Resources with tmp in name"
  runbook_type            = "PowerShell"
  content                 = data.local_file.tmp_runbook_powershell.content
  depends_on = [
    azurerm_resource_group.rgautomation,
    azurerm_automation_account.automation_account,
    data.local_file.tmp_runbook_powershell
  ]
  publish_content_link {
    uri = "https://www.microsoft.com" # Placeholder as Azure is dumb
  }
}