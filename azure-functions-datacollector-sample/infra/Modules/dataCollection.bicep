@description('')
param dataCollectionEndpointName string

@description('')
param dataCollectionRuleName string

@description('Location for resources')
param location string = resourceGroup().location

@description('')
param tags object


resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2021-09-01-preview' = {
  name: dataCollectionEndpointName
  location: location
  tags: tags
  kind: 'string'
  properties: {
    configurationAccess: {}
    description: 'string'
    immutableId: 'string'
    logsIngestion: {}
    networkAcls: {
      publicNetworkAccess: 'string'
    }
  }
}

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  name: dataCollectionRuleName
  location: location
  tags: tags
  kind: 'string'
  properties: {
    dataCollectionEndpointId: 'string'
    dataFlows: [
      {
        destinations: [
          'string'
        ]
        outputStream: 'string'
        streams: [
          'string'
        ]
        transformKql: 'string'
      }
    ]
    dataSources: {}
    description: 'string'
    destinations: {
      azureMonitorMetrics: {
        name: 'string'
      }
      logAnalytics: [
        {
          name: 'string'
          workspaceResourceId: 'string'
        }
      ]
    }
    streamDeclarations: {}
  }
}
