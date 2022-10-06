@description('The name of the corporation')
param corporationName string = 'bos'

@description('The name/id of the environment')
param environmentId string = 'dev01'

@description('The name of the service')
param serviceName string

@description('The loction of the resource')
param location string = resourceGroup().location

@description('The location short name of the service')
param locationShortName string = 'swn'

@description('')
param utcValue string = utcNow()

@description('')
param tags object


var functionAppName = 'func-${corporationName}-${serviceName}-${locationShortName}-${environmentId}'
var hostingPlanName = 'asp-${corporationName}-${serviceName}-${locationShortName}-${environmentId}'
var applicationInsightsName = 'aai-${corporationName}-${serviceName}-${locationShortName}-${environmentId}'
var storageAccountName = 'stfunc${serviceName}${locationShortName}${environmentId}'

var logAnalyticsWorkspaceName = 'law-${corporationName}-${serviceName}-${locationShortName}-${environmentId}' 
var clusterResourceId = ''
var defaultDataCollectionRuleResourceId = ''
var dataCollectionEndpointName = ''
var dataCollectionRuleName = ''


// Module Log Analytics Workspace
module logAnalyticsWorkspaceModule 'Modules/logAnalyticsWorkspace.bicep' = {
  name: 'module-logAnalyticsWorkspace-${utcValue}'
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    clusterResourceId: clusterResourceId
    defaultDataCollectionRuleResourceId: defaultDataCollectionRuleResourceId
    location: location
    tags: tags
  }
}

// Module Data collection
module dataCollectionModule 'Modules/dataCollection.bicep' = {
  name: 'module-dataCollectionModule-${utcValue}'
  params: {
    dataCollectionEndpointName: dataCollectionEndpointName
    dataCollectionRuleName: dataCollectionRuleName
    tags: tags
    location: location
  }
  //dependsOn: logAnalyticsWorkspaceModule.name
}

// Module Application insights
module appInsightsModule 'Modules/appInsight.bicep' = {
  name: 'module-appInsight-${utcValue}'
  params: {
    applicationInsightsName: applicationInsightsName
    location: location
    tags: tags
  }
}

// Module Funciton App
module functionAppModule 'Modules/functionApp.bicep' = {
  name: 'module-functionApp-${utcValue}'
  params: {
    functionAppName: functionAppName
    hostingPlanName: hostingPlanName
    storageAccountName: storageAccountName
    location: location
    tags: tags
    instrumentationKey: appInsightsModule.outputs.instrumentationKey
  }
}
