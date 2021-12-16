param
(
    [Parameter (Mandatory = $false)]
    [object] $WebhookData
)

<#
    .DESCRIPTION
        An example runbook which stops VMs from webhook data using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Bos Azure Automation Team
        LASTEDIT: July 08, 2021

    #Requires -Modules Az.Accounts, Az.Resources
#>

# configuration
$requestHeaderMessage = "StartedByTest"
$connectionName = "AzureRunAsConnection"

# If runbook was called from Webhook, WebhookData will not be null.
if ($WebhookData) 
{
    # Check header for message to validate request
    if ($WebhookData.RequestHeader.message -eq $requestHeaderMessage)
    {
        Write-Output -InputObject "Header has required information"}
    else
    {
        Write-Output -InputObject "Header missing required information";
        exit;
    }

    # Retrieve VMs from Webhook request body
    $vms = (ConvertFrom-Json -InputObject $WebhookData.RequestBody)

    # Authenticate to Azure by using the service principal and certificate. Then, set the subscription.
    try
    {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

        Write-Output -InputObject "Logging in to Azure..."
        Connect-AzAccount -ServicePrincipal -Tenant $servicePrincipalConnection.TenantId -ApplicationId $servicePrincipalConnection.ApplicationId -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
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

    # Stop each virtual machine
    foreach ($vm in $vms)
    {
        $vmInfo = Get-AzVM -ResourceGroupName $vm.ResourceGroup -Name $vm.Name  -Status
        if ($vmInfo.Statuses.Where({$_.Code -like "PowerState*"}).DisplayStatus -eq "VM running")
        {
            Write-Output -InputObject "Stopping VM ${vmName}"
            Stop-AzVM -ResourceGroupName $resourceGroup -Name $vmName -Force
        }
    }
}
else 
{
    # Error
    Write-Error -Message "This runbook is meant to be started from an Azure alert webhook only."
}