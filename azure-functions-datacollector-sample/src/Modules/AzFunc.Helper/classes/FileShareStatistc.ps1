<#
    .Synopsis
    FileShareStatistic Custom Log class
    .DESCRIPTION
    FileShareStatistic Custom Log class for CDR-based log table in Azure Log Analytics
    .EXAMPLE
    $fileShareStatistic = [FileShareStatistic]::new(
        "StorageAccountName",
        "FileShareName",
        1024,
        54165465464,
        "TenantId",
        "8d817bc9-f85d-436b-9235-895a41821ba9",
        "fa2c34ec-fe23-4fff-ba33-b008e9fedcb7"
    )
#>
class FileShareStatistic
{
    [string] $StorageAccountName
    [string] $FileShareName
    [int] $QuotaInGiB
    [long] $UsageInBytes
    [decimal] $UsageInGiB
    [string] $SourceSystem
    [string] $TenantId
    [datetime] $TimeGenerated
    [string] $Type
    [string] $_ResourceId
    [string] $_SubscriptionId

    FileShareStatistic(
        [string] $StorageAccountName,
        [string] $FileShareName,
        [int] $QuotaInGiB,
        [long] $UsageInBytes,
        [string] $TenantId,
        [string] $_ResourceId,
        [string] $_SubscriptionId
    )
    {
        $this.StorageAccountName = $StorageAccountName
        $this.FileShareName = $FileShareName
        $this.QuotaInGiB = $QuotaInGiB
        $this.UsageInBytes = $UsageInBytes
        $this.UsageInGiB = $UsageInBytes / 1073741824
        $this.SourceSystem = $StorageAccountName
        $this.TenantId = $TenantId
        $this.TimeGenerated = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        $this.Type = "FileShareStatistic_CL"
        $this._ResourceId = $_ResourceId
        $this._SubscriptionId = $_SubscriptionId
    }

    [string] WriteUsageToString()
    {
        # Write stats to std output
        $sb = [System.Text.StringBuilder]::new()
        [void]$sb.Append("File Share:`t`t`t$($this.FileShareName)`n")
        [void]$sb.Append("File Share Quota GiB:`t`t$($this.QuotaInGiB)`n")
        [void]$sb.Append("File Share Usage GiB:`t`t$([Math]::Round($this.UsageInGiB,2)) GiB`n")
        [void]$sb.Append("File Share Usage in percentage:`t$([Math]::Round(($this.UsageInGiB/$($this.QuotaInGiB))*100,2)) %`n")

        return $sb.ToString()
    }
}
