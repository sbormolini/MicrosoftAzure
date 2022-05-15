$resourceGroupName = "rg-bos-bicepVM-mpn-001"
$location = "switzerlandnorth"

Connect-AzAccount
New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzResourceGroupDeployment -Name "bicepVM-deplyoment" -ResourceGroupName $resourceGroupName -TemplateFile "./azuredeploy.json"

#Remove-AzResourceGroup -Name $resourceGroupName
