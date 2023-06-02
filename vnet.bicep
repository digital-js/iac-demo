param options object = {
  name: 'VNet1'
  addressPrefix: '10.0.0.0/22'
  subnets: [
    {
      name: 'firstSubnet'
      addressPrefix: '10.0.0.0/24'
    }
  ]
}

param location string

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: options.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        options.addressPrefix
      ]
    }
    subnets: [
      {
        name: options.subnets[0].name
        properties: {
          addressPrefix: options.subnets[0].addressPrefix
        }
      }
      {
        name: options.subnets[1].name
        properties: {
          addressPrefix: options.subnets[1].addressPrefix
        }
      }
    ]
  }
}

output vnet object = vnet
