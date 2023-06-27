// param resourceGroupName string
param appServiceName string
param appServicePlanName string
param location string
param envTag string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|v6.0'
    }
  }
}

resource stagingDeploymentSlot 'Microsoft.Web/sites/slots@2021-02-01' = if (envTag == 'qa') {
  parent: appService
  location: location
  name: 'staging'
  properties: {
    serverFarmId: appServicePlan.id
  }
}
