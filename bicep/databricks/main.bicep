@maxLength(15)
param databricksname string
param databricksLocation string = resourceGroup().location

module devDatabricks 'databricks.bicep' = {
  name: 'devDatabricks'
  params: {
    databricksLocation: databricksLocation
    databricksName: databricksname
    managedResourceGroupId: resourceGroup().id
  }
}
