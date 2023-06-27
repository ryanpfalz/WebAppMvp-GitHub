// param resourceGroupName string
param appServiceName string
param appServicePlanName string
param location string
param envTag string

module appServiceModule './appservice.bicep' = {
  name: appServiceName
  params: {
    // resourceGroupName: resourceGroupName
    appServiceName: appServiceName
    appServicePlanName: appServicePlanName
    location: location
    envTag: envTag
  }
}
