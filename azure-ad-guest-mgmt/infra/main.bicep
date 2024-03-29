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

param utcValue string = utcNow()


var functionAppName = 'func-${corporationName}-${serviceName}-${locationShortName}-${environmentId}'
var hostingPlanName = 'asp-${corporationName}-${serviceName}-${locationShortName}-${environmentId}'
var applicationInsightsName = 'aai-${corporationName}-${serviceName}-${locationShortName}-${environmentId}'
var storageAccountName = 'stfunc${serviceName}${locationShortName}${environmentId}'


// Module Application insights
module appInsightsModule 'Modules/appInsight.bicep' = {
  name: 'module-appInsight-${utcValue}'
  params:{
    applicationInsightsName: applicationInsightsName
    location: location
  }
}

// Module Function App
module functionAppModule 'Modules/functionApp.bicep' = {
  name: 'module-functionApp-${utcValue}'
  params: {
    functionAppName: functionAppName
    hostingPlanName: hostingPlanName
    storageAccountName: storageAccountName
    location: location
    instrumentationKey: appInsightsModule.outputs.instrumentationKey
  }
}
