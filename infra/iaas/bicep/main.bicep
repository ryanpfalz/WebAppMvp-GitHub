param vmName string
param location string
param vmSize string
param adminUsername string
@secure()
param adminPassword string

module virtualMachineModule './virtualmachine.bicep' = {
  name: vmName
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmName: vmName
    location: location
    vmSize: vmSize
  }
}
