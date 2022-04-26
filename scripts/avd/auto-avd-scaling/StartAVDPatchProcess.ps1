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

# disable avd scaling plan
$plan = Get-AzWvdScalingPlan -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName
if ($plan)
{  
    $newHostPoolReference = @(
        @{
            'hostPoolArmPath' = $plan.HostPoolReference.hostPoolArmPath;
            'scalingPlanEnabled' = $false;
        }
    )
    Write-Output "Update ScalingPlan '$($plan.Name)' with new HostPoolReference `npool: '$($newHostPoolReference.Values[0])' `nvalue: '$($newHostPoolReference.Values[1])'"
    Update-AzWvdScalingPlan -Name $plan.Name -ResourceGroupName $ResourceGroupName -HostPoolReference $newHostPoolReference
}
else 
{
    Write-Warning -Message "No AzWvdScalingPlan found for $($HostPoolName) in Resource Group $($ResourceGroupName)"    
}

$sessionHosts = Get-AzWvdSessionHost -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName
Write-Output "Discovered $($sessionHosts.Count) Session Host (vm) for Pool $($HostPoolName)"
$sessionHosts | ForEach-Object -Parallel {
    try 
    {
        $vmResource = Get-AzResource -Id $_.resourceId
        Write-Output "Start VM $($vmResource.Name)"
        Start-AzVM -ResourceGroupName $vmResource.ResourceGroupName -Name $vmResource.Name
    }
    catch 
    {
        Write-Warning -Message "Could not start VM $($_.resourceId).`n$($Error[0])"
    }
}