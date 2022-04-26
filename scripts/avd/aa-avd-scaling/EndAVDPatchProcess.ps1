param
(
    [Parameter(Mandatory = $true)]
    [System.String]$SubscriptionName,

	[Parameter(Mandatory = $true)]
    [System.String]$ResourceGroupName,

	[Parameter(Mandatory = $true)]
    [System.String]$HostPoolName
)

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process | Out-Null

# Connect using a Managed Service Identity
try 
{
    $AzureContext = (Connect-AzAccount -Identity).context
}
catch
{
    Write-Output "There is no system-assigned user identity. Aborting."; 
    exit
}

# Set and store context
$AzureContext = Set-AzContext -SubscriptionName $SubscriptionName -DefaultProfile $AzureContext

Import-Module -Name @(
	"Az.Resources",
	"Az.DesktopVirtualization"
)

$sessionHosts = Get-AzWvdSessionHost -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName
$sessionHosts | ForEach-Object -Parallel {
	$vmResource = Get-AzResource -Id $_.resourceId

    try
    {
        Write-Output "Remove 'Special' tag for VM $($vmResource.Name)"
        Update-AzTag -ResourceId $vmResource.Id -Tag @{"Special" = "Special"} -Operation Delete -Verbose
    }
    catch 
    {
        Write-Warning -Message "Could not remove 'Special' tag from VM $($_.resourceId).`n$($Error[0])"
    }
    try 
    {
        Write-Output "Restart VM $($vmResource.Name)"
        Restart-AzVM -ResourceGroupName $vmResource.ResourceGroupName -Name $vmResource.Name
    }
    catch 
    {
        Write-Warning -Message "Could not restart VM $($_.resourceId).`n$($Error[0])"
    }
}