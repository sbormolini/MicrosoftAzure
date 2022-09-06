using namespace System.Net

# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format.
$currentUTCtime = (Get-Date).ToUniversalTime()

# Write to the Azure Functions log stream.
Write-Host "PowerShell Timer trigger function started."

Write-Host "Get Share for $($env:StorageAccountName) using $($context.Context)"
#$context = New-AzStorageContext -UseConnectedAccount -StorageAccountName $env:StorageAccountName // not supported for files
$context = New-AzStorageContext -StorageAccountName $env:StorageAccountName -SasToken $env:SasToken 
$fileShares = Get-AzStorageShare -Context $context | Where-Object { $_.IsSnapshot -eq $false }

$statistics = @()
foreach ($fileShare in $fileShares)
{   
    # get file share usage data
    Write-Host "Get Share Usage for $($fileshare.Name) in $($env:StorageAccountName)"
    $parameters = @{
        ResourceGroupName = $env:ResourceGroupName
        StorageAccountName = $env:StorageAccountName
        Name = $fileshare.Name
    }
    $share = Get-AzRmStorageShare @parameters -GetShareUsage

    # add statistic object
    $parameters = @{
        StorageAccountName = $env:StorageAccountName
        FileShareName = $fileshare.Name
        QuotaInGiB = $fileshare.Quota
        UsageInBytes = $share.ShareUsageBytes
        TenantId = $env:TenantId
        ResourceId = $share.Id
        SubscriptionId = $share.Id.Split('/')[2]
    }
    $fileShareStatistic = New-FileShareStatistic @parameters
    Write-Host "Add following usage statistic to  data collection:"
    Write-Host $fileShareStatistic.GetUsageInformation()
    $statistics += $fileShareStatistic
}

# obtain token using managed identity
$token = (Get-AzAccessToken -ResourceUrl "https://monitor.azure.com/").Token

# send data to collection endpoint
Write-Host "Send data to collection endpoint $($env:DataCollectionEndpointURI)"
$parameters = @{
    DataCollectionEndpointURI = $env:DataCollectionEndpointURI
    DataCollectionRuleImmutableId = $env:DataCollectionRuleImmutableId
    TableName = $env:TableName
    LogObject = $statistics | ConvertTo-Json
    Token = $token
}
$body = Send-LogToDataCollectionEndpoint @parameters

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"