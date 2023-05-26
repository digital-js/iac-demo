param storageAccountName string
param storageAccountType string = 'Standard_LRS'
param location string = resourceGroup().location

module stg './storage-account.bicep' = {
  name: 'storageDeploy'
  params: {
    storageAccountName: storageAccountName
    storageAccountType: storageAccountType
    location: location
  }
}

output storageEndpoint object =  stg.outputs.storageEndpoint
