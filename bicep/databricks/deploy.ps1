$DatabricksName = "test"
$Location = "switzerlandnorth"
$Service = "DataProcess"
$ResourceGroupName = "rg-bos-$($Service.ToLower())-chn-dev01"
$Tags = @{
    Owner = "Sandro"
    Environment = "Dev"
    Service = $Service
}

# create resource group databricks workspace
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag $Tags

# create resource group databricks cluster
#New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag $Tags

# deploy resource with bicep
$parameters = @{
    ResourceGroupName = $ResourceGroupName
    Mode = "Complete"
    TemplateFile = "./main.bicep"
    storagePrefix = $DatabricksName
}
New-AzResourceGroupDeployment @parameters -Confirm:$false

# remove resource group
#Remove-AzResourceGroup -Name $ResourceGroupName