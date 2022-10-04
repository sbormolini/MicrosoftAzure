@description('Location for Application Insights')
param location string = resourceGroup().location

@description('The name of the function app that you wish to create.')
param applicationInsightsName string


resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

output instrumentationKey string = applicationInsights.properties.InstrumentationKey
