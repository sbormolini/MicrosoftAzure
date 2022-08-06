using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

class FileShareStatistic
{
    [string]$FileShareName
    [int]$QuotaInGB
    [string]$StorageAccountName
    [string]$TenantId
    [datetime]$TimeGenerated
    [string]$Type
    [decimal]$UsageInGB
    [string]$_ResourceId
    [string]$_SubscriptionId
}

$context = New-AzStorageContext -StorageAccountName $env:StorageAccountName -SasToken $env:SasToken 
#$context = New-AzStorageContext -StorageAccountName $env:StorageAccountName > bearer not supported for files
$fileShares = Get-AzStorageShare -Context $context | Where-Object { $_.IsSnapshot -eq $false }
$statistics = @()
foreach ($fileShare in $fileShares)
{   
    $parameters = @{
        ResourceGroupName = $env:ResourceGroupName
        StorageAccountName = $env:StorageAccountName
        Name = $fileshare.Name
    }
    $share = Get-AzRmStorageShare @parameters -GetShareUsage 
    $shareUsageGiB = $share.ShareUsageBytes / 1073741824

    # add statistic object
    $fileShareStatistic = [FileShareStatistic]::new()
    $fileShareStatistic.FileShareName = $fileshare.Name
    $fileShareStatistic.QuotaInGB = $fileshare.Quota
    $fileShareStatistic.StorageAccountName = $env:StorageAccountName
    $fileShareStatistic.TenantId = $env:TenantId
    $fileShareStatistic.TimeGenerated = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    $fileShareStatistic.Type = "FileShareStatistic_CL"
    $fileShareStatistic.UsageInGB = $shareUsageGiB
    $fileShareStatistic._ResourceId = $share.Id
    $fileShareStatistic._SubscriptionId = $share.Id.Split('/')[2]

    $statistics += $fileShareStatistic

    # show logs
    Write-Output "File Share: $($fileshare.Name)"
    Write-Output "File Share Usage GB: $([math]::Round($shareUsageGiB,2))GB"
    Write-Output "File Share Usage %: $([math]::Round(($shareUsageGiB/$($fileshare.Quota))*100,2))%"
}

$body = $statistics | ConvertTo-Json

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
