@minLength(5)
@maxLength(50)
@description('Name of the azure container registry (must be globally unique)')
param name string

@description('Enable an admin user that has push/pull permission to the registry.')
param adminUserEnabled bool = false

@description('Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('Tier of your Azure Container Registry.')
param sku string = 'Basic'

// azure container registry
resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: name
  location: location
  tags: {
    displayName: 'Container Registry'
    'container.registry': name
  }
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
  }
}

output acrLoginServer string = acr.properties.loginServer
