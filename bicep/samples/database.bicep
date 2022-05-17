param location string
param aadLoginName string
param aadLoginSid string
param aadLoginTenant string
param clientIpAddress string

// Generic DB Settings
var databaseName = 'sample-db-with-tde'
//var databaseEdition = 'Basic'
var databaseCollation = 'SQL_Latin1_General_CP1_CI_AS'
//var databaseServiceObjectiveName = 'Basic'
var sqlServerName = 'sqlserver${uniqueString(resourceGroup().id)}'

// Security Settings
var minTlsVersion = '1.2' // Should always be latest supported TLS version
//var transparentDataEncryption = 'Enabled' // Why would you ever disable this?
var sqlAdministratorLogin = 'user${uniqueString(resourceGroup().id)}' // Using AAD auth, so create random user
var sqlAdministratorLoginPassword = 'p@!!${uniqueString(resourceGroup().id)}' // Using AAD auth, so create random pw


resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
    minimalTlsVersion: minTlsVersion
  }
}

resource db 'Microsoft.Sql/servers/databases@2019-06-01-preview' = {
  name: '${sqlServer.name}/${databaseName}' 
  location: location
  properties: {
    //edition: databaseEdition
    collation: databaseCollation
    //requestedServiceObjectiveName: databaseServiceObjectiveName
  }
}

//resource tde 'Microsoft.Sql/servers/databases/transparentDataEncryption@2014-04-01-preview' = {
//  name: '${db.name}/current' 
//  properties: {
//    status: transparentDataEncryption
//  }
//}

resource aadLogin 'Microsoft.Sql/servers/administrators@2019-06-01-preview' = {
    name: '${sqlServer.name}/aadLogin'
    properties: {
        administratorType: 'ActiveDirectory'
        login: aadLoginName
        sid: aadLoginSid
        tenantId: aadLoginTenant
    }
}

resource fwRule 'Microsoft.Sql/servers/firewallRules@2015-05-01-preview' = {
    name: '${sqlServer.name}/fwRule1'
    properties: {
        startIpAddress: clientIpAddress
        endIpAddress: clientIpAddress
    }
}
