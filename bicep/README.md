# bicep
Bicep library


## bicep-vm
A quick VM setup on Azure using Bicep

https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview

### Build
bicep build main.bicep --outfile ./build/azuredeploy.json

### Run
- az login
- az account set --subscription "your subscription id"
- az group create --name "resource-group" --location "your location"
- az group deployment create --name "name of your deployment" --resource-group "resource-group" --template-file "./azuredeploy.json"
