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
Write-Output "Discovered $($sessionHosts.Count) Session Host (vm) for Pool $($HostPoolName)"
$sessionHosts | ForEach-Object -Parallel {
    $vmResource = Get-AzResource -Id $_.resourceId
    try
    {
        Write-Output "Set new 'Special' tag for VM $($vmResource.Name)"
        $vmResource.Tags.Add("Special", "Special")
        $vmResource | Set-AzResource -Force
    }
    catch 
    {
        Write-Warning -Message "Could not add 'Special' tag to VM $($_.resourceId).`n$($Error[0])"
    }
    try 
    {
        Write-Output "Start VM $($vmResource.Name)"
        Start-AzVM -ResourceGroupName $vmResource.ResourceGroupName -Name $vmResource.Name
    }
    catch 
    {
        Write-Warning -Message "Could not start VM $($_.resourceId).`n$($Error[0])"
    }
}