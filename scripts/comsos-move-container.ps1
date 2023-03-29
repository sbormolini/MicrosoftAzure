#Requires -Modules Az.DataFactory

$pipelineNameBackup = "pl-backup-container-{env}"
Write-Host "Run ADF Backup pipeline $($pipelineNameBackup)"

# start pipeline
$parameters = @{
    ResourceGroupName = "$(resourceGroupNameDataFactory)"
    DataFactoryName = "$(dataFactoryName)"
    PipelineName = $pipelineNameBackup
}
$pipelineRunId = Invoke-AzDataFactoryV2Pipeline @parameters

# monitor pipeline
$completed = $false
while (-not$completed) {
    $parameters = @{
        ResourceGroupName = "$(resourceGroupNameDataFactory)"
        DataFactoryName = "$(dataFactoryName)"
        $PipelineRunId = $pipelineRunId
    }
    $pipelineRun = Get-AzDataFactoryV2PipelineRun @parameters

    if (
        ($pipelineRun.Status -eq "Succeeded") -or 
        ($pipelineRun.Status -eq "Failed") -or 
        ($pipelineRun.Status -eq "Cancelled")) {
        $completed = $true
    }
    else {
        Start-Sleep -Seconds 15
    }
}

# output status
Write-Host "Pipeline run $pipelineRunId completed with status $($pipelineRun.Status)"


#Requires -Modules Az.CosmosDB

$resourceGroupNameCosmosDB = "rg-cosmosDB-{env}"
$accountName = "cdb-test-{env}"
Write-Host "Delete target container $(containerName) from $accountName in $resourceGroupNameCosmosDB"

$parameters = @{
    ResourceGroupName = $resourceGroupNameCosmosDB
    AccountName = $accountName
    DatabaseName = "$(databaseName)"
    Name = "$(containername)"
}
Remove-AzCosmosDBSqlContainer @parameters

Start-Sleep -Seconds 15


#Requires -Modules Az.CosmosDB

$resourceGroupNameCosmosDB = "rg-cosmosDB-{env}"
$accountName = "cdb-test-{env}"
Write-Host "Get target container $(containerName) troughput from $accountName in $resourceGroupNameCosmosDB"

$parameters = @{
    ResourceGroupName = $resourceGroupNameCosmosDB
    AccountName = $accountName
    DatabaseName = "$(databaseName)"
    Name = "$(containername)"
}
Get-AzCosmosDBSqlContainerThroughput @parameters

Start-Sleep -Seconds 15


#Requires -Modules Az.CosmosDB

$resourceGroupNameCosmosDB = "rg-cosmosDB-{env}"
$accountName = "cdb-test-{env}"
$autoscaleMaxThroughput = 4000
Write-Host "Update target container $(containerName) troughput to $autoscaleMaxThroughput in $accountName in $resourceGroupNameCosmosDB"

$parameters = @{
    ResourceGroupName = $resourceGroupNameCosmosDB
    AccountName = $accountName
    DatabaseName = "$(databaseName)"
    Name = "$(containername)"
    AutoscaleMaxThroughput = $autoscaleMaxThroughput
}
Update-AzCosmosDBSqlContainerThroughput @parameters

Start-Sleep -Seconds 15


#Requires -Modules Az.CosmosDB

$resourceGroupNameCosmosDB = "rg-cosmosDB-{env}"
$accountName = "cdb-test-{env}"
Write-Host "Create target container $(containerName) in $accountName in $resourceGroupNameCosmosDB"

$parameters = @{
    ResourceGroupName = $resourceGroupNameCosmosDB
    AccountName = $accountName
    DatabaseName = "$(databaseName)"
    Name = "$(containername)"
    PartitionKeyPath = "/key"
    PartitionKeyKind = "Hash"
}
New-AzCosmosDBSqlContainer @parameters

Start-Sleep -Seconds 15


#Requires -Modules Az.DataFactory

$pipelineNameCopy = "pl-copy-container-{env}-to-{env}"
Write-Host "Run ADF Backup pipeline $($pipelineNameCopy)"

# start pipeline
$parameters = @{
    ResourceGroupName = "$(resourceGroupNameDataFactory)"
    DataFactoryName = "$(dataFactoryName)"
    PipelineName = $pipelineNameCopy
}
$pipelineRunId = Invoke-AzDataFactoryV2Pipeline @parameters

# monitor pipeline
$completed = $false
while (-not$completed) {
    $parameters = @{
        ResourceGroupName = "$(resourceGroupNameDataFactory)"
        DataFactoryName = "$(dataFactoryName)"
        $PipelineRunId = $pipelineRunId
    }
    $pipelineRun = Get-AzDataFactoryV2PipelineRun @parameters

    if (
        ($pipelineRun.Status -eq "Succeeded") -or 
        ($pipelineRun.Status -eq "Failed") -or 
        ($pipelineRun.Status -eq "Cancelled")) {
        $completed = $true
    }
    else {
        Start-Sleep -Seconds 15
    }
}

# output status
Write-Host "Pipeline run $pipelineRunId completed with status $($pipelineRun.Status)"

