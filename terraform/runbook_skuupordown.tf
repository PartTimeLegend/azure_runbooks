data "local_file" "skuupordown_runbook_powershell" {
    filename = "../SkuUpOrDown.ps1"
  }
  
  resource "azurerm_automation_runbook" "skuupordown_automation_runbook" {
    name                    = "rb-skuupordown-${local.az_region_abbrv}"
    location                = azurerm_automation_account.automation_account.location
    resource_group_name     = azurerm_resource_group.rgautomation.name
    automation_account_name = azurerm_automation_account.automation_account.name
    log_verbose             = "true"
    log_progress            = "true"
    description             = "Upgrades or downgrades the SKU for products depending on the hour of day."
    runbook_type            = "PowerShell"
    content                 = data.local_file.skuupordown_runbook_powershell.content
    depends_on = [
      azurerm_resource_group.rgautomation,
      azurerm_automation_account.automation_account,
      data.local_file.skuupordown_runbook_powershell
    ]
    publish_content_link {
      uri = "https://www.microsoft.com" # Placeholder as Azure is dumb
    }
  }
  
  
  resource "azurerm_automation_job_schedule" "skuupordown_automation_job_schedule" {
    resource_group_name     = azurerm_resource_group.rgautomation.name
    automation_account_name = azurerm_automation_account.automation_account.name
    schedule_name           = azurerm_automation_schedule.automation_schedule_onehours.name
    runbook_name            = azurerm_automation_runbook.skuupordown_automation_runbook.name
  }