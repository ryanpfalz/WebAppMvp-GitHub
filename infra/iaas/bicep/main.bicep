param vmName string
param location string
param vmSize string
param adminUsername string
@secure()
param adminPassword string

// module virtualMachineModule './virtualmachine-linux.bicep' = {
//   name: vmName
//   params: {
//     adminUsername: adminUsername
//     adminPassword: adminPassword
//     vmName: vmName
//     location: location
//     vmSize: vmSize
//   }
// }

module virtualMachineModule './virtualmachine-windows.bicep' = {
  name: vmName
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmName: vmName
    location: location
    vmSize: vmSize
  }
}
