resource "azurerm_automation_account" "automation_account" {
  name                = "${var.automation_account_name}-${local.az_region_abbrv}"
  location            = azurerm_resource_group.rgautomation.location
  resource_group_name = azurerm_resource_group.rgautomation.name
  sku_name            = "Basic"
  depends_on = [
    azurerm_resource_group.rgautomation
  ]
}

resource "azurerm_automation_module" "az_accounts" {
  name                    = "Az.Accounts"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/az.accounts.2.3.0.nupkg"
  }
  depends_on = [
    azurerm_resource_group.rgautomation,
    azurerm_automation_account.automation_account
  ]
}

resource "azurerm_automation_module" "az_resources" {
  name                    = "Az.Resources"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/az.resources.4.1.1.nupkg"
  }
  depends_on = [
    azurerm_resource_group.rgautomation,
    azurerm_automation_account.automation_account,
    azurerm_automation_module.az_accounts
  ]
}

resource "azurerm_automation_module" "az_apimanagement" {
  name                    = "Az.ApiManagement"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/az.apimanagement.2.1.0.nupkg"
  }
  depends_on = [
    azurerm_resource_group.rgautomation,
    azurerm_automation_account.automation_account,
    azurerm_automation_module.az_accounts
  ]
}

resource "azurerm_automation_schedule" "automation_schedule_sixhours" {
  name                    = "as-sixhours-${local.az_region_abbrv}"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "Hour"
  interval                = 6
  description             = "Runs every 6 hours"
}

resource "azurerm_automation_schedule" "automation_schedule_onehours" {
  name                    = "as-onehours-${local.az_region_abbrv}"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "Hour"
  interval                = 1
  description             = "Runs every 1 hour"
}

resource "azurerm_automation_schedule" "automation_schedule_oneday" {
  name                    = "as-onehours-${local.az_region_abbrv}"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "Day"
  interval                = 1
  description             = "Runs every 1 day"
}

resource "azurerm_automation_schedule" "automation_schedule_sevenday" {
  name                    = "as-onehours-${local.az_region_abbrv}"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "Day"
  interval                = 7
  description             = "Runs every 7 days"
}
