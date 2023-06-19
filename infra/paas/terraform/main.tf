terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.76.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.module_resource_group_name
  location = var.module_location
}

module "app_service" {
  source                     = "./modules/appservice"
  module_resource_group_name = azurerm_resource_group.rg.name
  module_location            = azurerm_resource_group.rg.location
  module_app_service_name    = var.module_app_service_name
  module_app_service_plan    = var.module_app_service_plan
  module_env_tag             = var.module_env_tag
}
