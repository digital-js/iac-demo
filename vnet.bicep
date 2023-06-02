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
  }
}

@batchSize(1)
resource subnets 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = [for (sn, index) in options.subnets: {
  name: sn.name
  parent: vnet
  properties: {
    addressPrefix: sn.subnetPrefix
  }
}]

output vnet object = vnet
