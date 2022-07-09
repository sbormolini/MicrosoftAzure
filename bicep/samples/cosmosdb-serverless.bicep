@description('Location for all resources.')
param location string = resourceGroup().location

@description('Cosmos DB account name, max length 44 characters')
param accountName string = toLower('sql-rbac-${uniqueString(resourceGroup().id)}')

@description('SQL Role Definition Id')
param roleDefinitionId string

@description('Object ID of the AAD identity. Must be a GUID.')
param principalId string

@description('The name for the database')
param databaseName string

@description('The name for the container')
param containerName string

@description('The name for the lease container')
param leaseContainerName string = '${containerName}lease'

var locations = [
  {
    locationName: location
    failoverPriority: 0
    isZoneRedundant: false
  }
]

var roleAssignmentId = guid(roleDefinitionId, principalId, databaseAccount.id)

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: accountName
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: locations
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-01-15' = {
  parent: databaseAccount
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource databaseContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-01-15' = {
  parent: sqlDatabase
  name: containerName
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          '/categoryId'
        ]
        kind: 'Hash'
      }
    }
  }
}

resource databaseContainerLease 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-01-15' = {
  parent: sqlDatabase
  name: leaseContainerName
  properties: {
    resource: {
      id: leaseContainerName
      partitionKey: {
        paths: [
          '/partitionKey'
        ]
        kind: 'Hash'
      }
    }
  }
}

resource sqlRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-04-15' = {
  name: '${databaseAccount.name}/${roleAssignmentId}'
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    scope: databaseAccount.id
  }
}
