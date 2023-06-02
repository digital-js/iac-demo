@description('Specifies the name of the virtual network.')
param vnetName string = 'vnet-${uniqueString(resourceGroup().id)}'

@description('Address prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Specifies the location for all resources.')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}
