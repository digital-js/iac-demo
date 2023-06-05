param acrName string
param acrSku string
param acrAdminUser bool
param cosmosAccountName string
param cosmosDatabaseName string
param storageAccountName string
param vnetOptions object
param containerAppOptions object
param storageAccountSku string = 'Standard_LRS'
param location string = resourceGroup().location

module vnet './vnet.bicep' = {
  name: 'vnetDeploy'
  params: {
    options: vnetOptions
    location: location
  }
}

output vnet object = vnet.outputs.vnet

module stg './storage-account.bicep' = {
  name: 'storageDeploy'
  params: {
    storageAccountName: storageAccountName
    storageAccountSku: storageAccountSku
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

module cosmos './cosmos-db.bicep' = {
  name: 'cosmosDeploy'
  params: {
    accountName: cosmosAccountName
    databaseName: cosmosDatabaseName
    location: location
  }
}

module containerApp './container-app.bicep' = {
  name: 'containerAppDeploy'
  params: {
    options: containerAppOptions
    location: location
  }
}
