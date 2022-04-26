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

# restart vms from pool
$sessionHosts = Get-AzWvdSessionHost -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName
$sessionHosts | ForEach-Object -Parallel {
    try 
    {
        $vmResource = Get-AzResource -Id $_.resourceId
        Write-Output "Restart VM $($vmResource.Name)"
        Restart-AzVM -ResourceGroupName $vmResource.ResourceGroupName -Name $vmResource.Name
    }
    catch 
    {
        Write-Warning -Message "Could not restart VM $($_.resourceId).`n$($Error[0])"
    }
}

# enable avd scaling plan
$plan = Get-AzWvdScalingPlan -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName
if ($plan)
{  
    $newHostPoolReference = @(
        @{
            'hostPoolArmPath' = $plan.HostPoolReference.hostPoolArmPath;
            'scalingPlanEnabled' = $true;
        }
    )
    Write-Output "Update ScalingPlan '$($plan.Name)' with new HostPoolReference `npool: '$($newHostPoolReference.Values[0])' `nvalue: '$($newHostPoolReference.Values[1])'"
    Update-AzWvdScalingPlan -Name $plan.Name -ResourceGroupName $ResourceGroupName -HostPoolReference $newHostPoolReference
}
else 
{
    Write-Warning -Message "No AzWvdScalingPlan found for $($HostPoolName) in Resource Group $($ResourceGroupName)"    
}