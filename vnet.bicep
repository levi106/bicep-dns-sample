param name string
param location string
param vnetPrefix string
param subnetPrefix string
param dnsServers array = []

resource vnet 'Microsoft.Network/virtualNetworks@2019-12-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
    dhcpOptions: {
      dnsServers: dnsServers
    }
  }
}

output name string = vnet.name
