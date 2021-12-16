Param
(
  [Parameter(Mandatory= $true)]
  [String]$Name
)

<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Bos Azure Automation Team
        LASTEDIT: July 08, 2021

    #Requires -Modules Az.Accounts, Az.Resources
#>

$connectionName = "AzureRunAsConnection"
$resourceGroup = "rg-bos-automationdemo-mpn-001"
#$vmName = "az-ubuntu-vm01"
$vmName = $Name

try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Connect-AzAccount -ServicePrincipal `
                      -Tenant $servicePrincipalConnection.TenantId `
                      -ApplicationId $servicePrincipalConnection.ApplicationId `
                      -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch 
{
    if (-not$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } 
    else
    {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

# stop vm
$vm = Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName -Status
if ($vm.Statuses.Where({$_.Code -like "PowerState*"}).DisplayStatus -eq "VM running")
{
    "Stopping VM ${vmName}"
    Stop-AzVM -ResourceGroupName $resourceGroup -Name $vmName -Force
}
