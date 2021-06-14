resource "azuread_service_principal" "service_principal" {
  application_id = azuread_application.ad_application.application_id

  depends_on = [
    azuread_application_certificate.application_certificate,
  ]
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.service_principal.object_id
  depends_on = [
    azuread_service_principal.service_principal
  ]
}

resource "azurerm_automation_certificate" "automation_certificate" {
  name                    = "AzureRunAsCertificate"
  resource_group_name     = azurerm_automation_account.automation_account.resource_group_name
  automation_account_name = azurerm_automation_account.automation_account.name
  base64                  = filebase64("../secure/certificate.pfx")
  depends_on = [
    azurerm_automation_account.automation_account
  ]
}

resource "azurerm_automation_connection_service_principal" "test" {
  name                    = "AzureRunAsConnection"
  resource_group_name     = azurerm_automation_account.automation_account.resource_group_name
  automation_account_name = azurerm_automation_account.automation_account.name
  application_id          = azuread_service_principal.service_principal.application_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  subscription_id         = data.azurerm_client_config.current.subscription_id
  certificate_thumbprint  = azurerm_automation_certificate.automation_certificate.thumbprint
  depends_on = [
    azurerm_automation_account.automation_account,
    azuread_service_principal.service_principal,
    data.azurerm_client_config.current,
    azurerm_automation_certificate.automation_certificate
  ]
}