using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$context = New-AzStorageContext -StorageAccountName $env:StorageAccountName -SasToken $env:SasToken 
$fileShares = Get-AzStorageShare -Context $context | Where-Object { $_.IsSnapshot -eq $false }
$statistics = @()

foreach ($fileShare in $fileShares)
{   
    # get file share usage data
    $parameters = @{
        ResourceGroupName = $env:ResourceGroupName
        StorageAccountName = $env:StorageAccountName
        Name = $fileshare.Name
    }
    $share = Get-AzRmStorageShare @parameters -GetShareUsage

    # add statistic object
    $fileShareStatistic = [FileShareStatistic]::new(
        $env:StorageAccountName,
        $fileshare.Name,
        $fileshare.Quota,
        $share.ShareUsageBytes,
        $env:TenantId,
        $share.Id,
        $share.Id.Split('/')[2]
    )
    Write-Host $fileShareStatistic.WriteUsageToString()
    $statistics += $fileShareStatistic
}

# send data to collection endpoint
$parameters = @{
    DataCollectionEndpointURI = $env:DataCollectionEndpointURI
    DataCollectionRuleImmutableId = $env:DataCollectionRuleImmutableId
    TableName = $env:TableName
    LogObject = $statistics | ConvertTo-Json
    TenantId = $env:TenantId
    ClientId = $env:ClientId
    ClientSecret = $env:ClientSecret
}
$body = Send-LogToDataCollectionEndpoint @parameters

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
