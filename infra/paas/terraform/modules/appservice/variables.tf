variable "module_resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "module_app_service_name" {
  description = "Name of the Azure App Service."
  type        = string
}

variable "module_app_service_plan" {
  description = "Name of the Azure App Service Plan."
  type        = string
}

variable "module_location" {
  description = "Name of the resource location."
  type        = string
}

variable "module_env_tag" {
  description = "Tag for the environment."
  type        = string
}