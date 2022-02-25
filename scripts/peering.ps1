az vm create \
    --resource-group learn-06f96317-8ea6-4f38-8b55-e1c76d31147e \
    --no-wait \
    --name SalesVM \
    --location northeurope \
    --vnet-name SalesVNet \
    --subnet Apps \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password <password>

az vm create \
    --resource-group learn-06f96317-8ea6-4f38-8b55-e1c76d31147e \
    --no-wait \
    --name ResearchVM \
    --location westeurope \
    --vnet-name ResearchVNet \
    --subnet Data \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password <password>

watch -d -n 5 "az vm list \
    --resource-group learn-06f96317-8ea6-4f38-8b55-e1c76d31147e \
    --show-details \
    --query '[*].{Name:name, ProvisioningState:provisioningState, PowerState:powerState}' \
    --output table"