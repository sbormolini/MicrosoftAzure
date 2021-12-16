$StorageName = "kek"
$ResourceGroupName = "rg-bicep-mpn-switzerlandnorth-001"

# create resource group
New-AzResourceGroup -Name $ResourceGroupName -Location "switzerlandnorth"

# deploy resource with bicep
$parameters = @{
    ResourceGroupName = $ResourceGroupName
    Mode = "Complete"
    TemplateFile = "./main.bicep"
    storagePrefix = $StorageName
}
New-AzResourceGroupDeployment @parameters -Confirm:$false

<#

ResourceGroupName       : rg-bicep-mpn-switzerlandnorth-001
OnErrorDeployment       :
DeploymentName          : main
CorrelationId           : 5e55fded-5a83-4b7b-9fab-94cbdebd7257
ProvisioningState       : Succeeded
Timestamp               : 08/09/2021 20:54:38
Mode                    : Complete
TemplateLink            :
TemplateLinkString      :
DeploymentDebugLogLevel :
Parameters              : {[storagePrefix, Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.DeploymentVariable], [storageLocation, Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.DeploymentVariable]}
Tags                    :
ParametersString        :
                          Name               Type                       Value     
                          =================  =========================  ==========
                          storagePrefix      String                     kek
                          storageLocation    String                     switzerlandnorth

Outputs                 :
OutputsString           :

#>

# remove resource group
#Remove-AzResourceGroup -Name $ResourceGroupName