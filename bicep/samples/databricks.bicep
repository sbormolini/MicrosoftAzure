param databricksLocation string
param databricksName string
param managedResourceGroupId string

resource databricks 'Microsoft.Databricks/workspaces@2021-04-01-preview' = {
  name: databricksName
  location: databricksLocation
  properties: {
    managedResourceGroupId: managedResourceGroupId
  }
}
