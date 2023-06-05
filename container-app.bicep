param options object = {
  name: 'app-${uniqueString(resourceGroup().id)}'
  envName: 'env-${uniqueString(resourceGroup().id)}'
  logAnalyticsName: 'log-${uniqueString(resourceGroup().id)}'
  vnetName: 'vnet-${uniqueString(resourceGroup().id)}'
  vnetAddressPrefix: '10.0.0.0/16'
  envSubnetName: 'Subnet1'
  envSubnetPrefix: '10.0.0.0/23'
  imageName: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
  targetPort: 80
}

@description('Specifies the location for all resources.')
param location string = resourceGroup().location

@description('Number of CPU cores the container can use. Can be with a maximum of two decimals.')
@allowed([
  '0.25'
  '0.5'
  '0.75'
  '1'
  '1.25'
  '1.5'
  '1.75'
  '2'
])
param cpuCore string = '0.5'

@description('Amount of memory (in gibibytes, GiB) allocated to the container up to 4GiB. Can be with a maximum of two decimals. Ratio with CPU cores must be equal to 2.')
@allowed([
  '0.5'
  '1'
  '1.5'
  '2'
  '3'
  '3.5'
  '4'
])
param memorySize string = '1'

@description('Minimum number of replicas that will be deployed')
@minValue(0)
@maxValue(25)
param minReplicas int = 1

@description('Maximum number of replicas that will be deployed')
@minValue(0)
@maxValue(25)
param maxReplicas int = 3

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: options.logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: options.vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        options.vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: options.envSubnetName
        properties: {
          addressPrefix: options.envSubnetPrefix
        }
      }
    ]
  }
}

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: options.envName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
    vnetConfiguration: {
      infrastructureSubnetId: vnet.properties.subnets[0].id
    }
  }
}

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: options.name
  location: location
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      ingress: {
        external: true
        targetPort: options.targetPort
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
    }
    template: {
      revisionSuffix: 'firstrevision'
      containers: [
        {
          name: options.name
          image: options.imageName
          resources: {
            cpu: json(cpuCore)
            memory: '${memorySize}Gi'
          }
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

output containerAppFQDN string = containerApp.properties.configuration.ingress.fqdn
