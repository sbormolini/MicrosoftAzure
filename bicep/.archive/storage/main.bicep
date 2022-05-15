@maxLength(11)
param storagePrefix string
param storageLocation string = resourceGroup().location

// generate storage name
var storageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

module devStorageAcctount 'storage.bicep' = {
  name: 'devStorageAcctount'
  params: {
    storageLocation: storageLocation
    storageName: storageName
  }
}
