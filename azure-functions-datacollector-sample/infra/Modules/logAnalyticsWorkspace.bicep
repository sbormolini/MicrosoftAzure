@description('')
param logAnalyticsWorkspaceName string

@description('Location for resources')
param location string = resourceGroup().location

@description('')
param clusterResourceId string

@description('')
param defaultDataCollectionRuleResourceId string

@description('')
param tags object


resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
  properties: {
    defaultDataCollectionRuleResourceId: defaultDataCollectionRuleResourceId
    features: {
      clusterResourceId: clusterResourceId
      disableLocalAuth: true
      enableDataExport: true
      enableLogAccessUsingOnlyResourcePermissions: true
      immediatePurgeDataOn30Days: true
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 30
    sku: {
      capacityReservationLevel: 1
      name: 'pergb2018'
    }
    workspaceCapping: {
      dailyQuotaGb: json('-1')
    }
  }
}
