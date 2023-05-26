param acrName string
param acrSku string
param acrAdminUser bool
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

output storageAccountId string =  stg.outputs.storageAccountId
output storageAccountEndpoints object =  stg.outputs.storeageAccountEndpoints

module acr './container-registry.bicep' = {
  name: 'acrDeploy'
  params: {
    name: acrName
    adminUserEnabled: acrAdminUser
    location: location
    sku: acrSku
  }
}

output acrLoginServer string = acr.outputs.acrLoginServer
