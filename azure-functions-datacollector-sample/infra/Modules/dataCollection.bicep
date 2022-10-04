@description('Location for resources')
param location string = resourceGroup().location


resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2021-09-01-preview' = {
  name: 'string'
  location: location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
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
  name: 'string'
  location: location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
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
