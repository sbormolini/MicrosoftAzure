$uri = "https://4f0d7f82-ae18-4139-84ee-ef7df89acf50.webhook.stzn.azure-automation.net/webhooks?token=Neds6qZ%2bGt77I5dHD2lnrDjf1TgyMKIXW1GsLEsLdZk%3d"

$vms  = @(
    @{ Name="az-ubuntu-vm01"; ResourceGroup="rg-bos-automationdemo-mpn-001"}
)

$body = ConvertTo-Json -InputObject $vms
$header = @{ message="StartedByTest"}
$response = Invoke-WebRequest -Method Post -Uri $uri -Body $body -Headers $header

$jobid = (ConvertFrom-Json ($response.Content)).jobids[0]
$jobid 