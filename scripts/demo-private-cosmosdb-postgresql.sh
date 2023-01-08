az group create \
	--name rg-cpsql-demo \
	--location eastus

az network vnet create \
	--resource-group rg-cpsql-demo \
	--name cpsql-demo-net \
	--address-prefix 10.0.0.0/16

az network nsg create \
	--resource-group rg-cpsql-demo \
	--name cpsql-demo-nsg

az network vnet subnet create \
	--resource-group rg-cpsql-demo \
	--vnet-name cpsql-demo-net \
	--name cpsql-demo-subnet \
	--address-prefixes 10.0.1.0/24 \
	--network-security-group cpsql-demo-nsg


# provision the VM

az vm create \
	--resource-group rg-cpsql-demo \
	--name cpsql-demo-vm \
	--vnet-name cpsql-demo-net \
	--subnet cpsql-demo-subnet \
	--nsg cpsql-demo-nsg \
	--public-ip-address cpsql-demo-net-ip \
	--image debian \
	--admin-username azureuser \
	--generate-ssh-keys

# install psql database client

az vm run-command invoke \
	--resource-group rg-cpsql-demo \
	--name cpsql-demo-vm \
	--command-id RunShellScript \
	--scripts \
		"sudo touch /home/azureuser/.hushlogin" \
		"sudo DEBIAN_FRONTEND=noninteractive apt-get update" \
		"sudo DEBIAN_FRONTEND=noninteractive apt-get install -q -y postgresql-client"



# replace {your_password} in the string with your actual password

PG_URI='host=c.{resource_name}.postgres.database.azure.com port=5432 dbname=citus user=citus password={your_password} sslmode=require'

# Attempt to connect to cluster with psql in the VM

az vm run-command invoke \
	--resource-group rg-cpsql-demo \
	--name cpsql-demo-vm \
	--command-id RunShellScript \
	--scripts "psql '$PG_URI' -c 'SHOW citus.version;'" \
	--query 'value[0].message' \
	| xargs -0 printf