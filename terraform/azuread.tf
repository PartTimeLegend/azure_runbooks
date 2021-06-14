resource "azuread_application" "ad_application" {
  display_name = format("%s_%s", azurerm_automation_account.automation_account.name, random_string.random.result)
  depends_on = [
    azurerm_automation_account.automation_account
  ]
}

resource "azuread_application_certificate" "application_certificate" {
  application_object_id = azuread_application.ad_application.id
  type                  = "AsymmetricX509Cert"
  value                 = file("../secure/certificate.crt")
  end_date              = var.cert_end_date
  depends_on = [
    azurerm_resource_group.rgautomation,
    azuread_application.ad_application
  ]
}