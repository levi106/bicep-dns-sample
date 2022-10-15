param location string = resourceGroup().location
param vnetPrefix string = '172.17.0.0/16'
param subnetPrefix string = '172.17.0.0/24'
param privateIPAddress string = '172.17.0.10'
param adminUsername string = 'azureuser'
@secure()
param adminPassword string

module vnet 'vnet.bicep' = {
  name: 'vnet'
  scope: resourceGroup()
  params: {
    name: 'vnet'
    location: location
    vnetPrefix: vnetPrefix
    subnetPrefix: subnetPrefix
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  name: '${vnet.name}/default'
}

module vm 'vm.bicep' = {
  name: 'vm1'
  scope: resourceGroup()
  dependsOn: [vnet]
  params: {
    name: 'VM1'
    location: location
    subnetId: subnet.id
    privateIPAddress: privateIPAddress
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module vnet_with_dns 'vnet.bicep' = {
  name: 'vnet-with-dns'
  scope: resourceGroup()
  dependsOn: [vm]
  params: {
    name: vnet.outputs.name
    location: location
    vnetPrefix: vnetPrefix
    subnetPrefix: subnetPrefix
    dnsServers: [privateIPAddress]
  }
}
