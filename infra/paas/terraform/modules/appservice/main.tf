# https://learn.microsoft.com/en-us/azure/developer/terraform/provision-infrastructure-using-azure-deployment-slots
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.module_app_service_plan
  location            = var.module_location
  resource_group_name = var.module_resource_group_name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = var.module_app_service_name
  location            = var.module_location
  resource_group_name = var.module_resource_group_name
  app_service_plan_id     = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "DOTNETCORE|v6.0"
  }
}

# https://learn.microsoft.com/en-us/azure/developer/terraform/provision-infrastructure-using-azure-deployment-slots
resource "azurerm_app_service_slot" "staging_deployment_slot" {
  count               = var.module_env_tag == "qa" ? 1 : 0
  name                = "staging"
  resource_group_name = var.module_resource_group_name
  location            = azurerm_app_service_plan.app_service_plan.location
  app_service_name    = azurerm_app_service.app_service.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

}
