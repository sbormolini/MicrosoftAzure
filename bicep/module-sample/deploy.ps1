Connect-AzAccount

<#
$context = Get-AzSubscription -SubscriptionName 'Concierge Subscription'
Set-AzContext $context

Get-AzSubscription

$context = Get-AzSubscription -SubscriptionId {Your subscription ID}
Set-AzContext $context

Set-AzDefault -ResourceGroupName [sandbox resource group name]
#>

$tags = @{
    Environment = "Dev"
    Owner = "Sandro"
    Service = "Bicep sample"
}

# create resource group
$resourceGroupName = "rg-bos-bicepsample-chn-dev01"
New-AzResourceGroup -Name $resourceGroupName -Location "switzerlandnorth" -Tag $tags

# deploy resource with bicep
$parameters = @{
    ResourceGroupName = $resourceGroupName
    Mode = "Complete"
    TemplateFile = "./main.bicep"
    Tag = $tags
}
New-AzResourceGroupDeployment @parameters -Confirm:$false
