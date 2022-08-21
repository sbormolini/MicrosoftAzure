<#
.Synopsis
   New-FileShareStatistic
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   New-FileShareStatistic -StorageAccountName "StorageAccountName" -FileShareName "FileShareName" -QuotaInGiB 1024 -UsageInBytes 54165465464 -TenantId "TenantId" -ResourceId "ResourceId" -SubscriptionId "SubscriptionId"
#>

function New-FileShareStatistic
{
    param 
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $StorageAccountName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $FileShareName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int] $QuotaInGiB,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [long] $UsageInBytes,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $TenantId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ResourceId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $SubscriptionId
    )

    try 
    {
        return [FileShareStatistic]::new(
            $StorageAccountName,
            $FileShareName,
            $QuotaInGiB,
            $UsageInBytes,
            $TenantId,
            $ResourceId,
            $SubscriptionId
        )
    }
    catch 
    {
        {1:<#Do this if a terminating exception happens#>}
    }
}