using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$length = $Request.Query.Length
if (-not $length) 
{
    $length = $Request.Body.Length
}

Write-Host "Generate random password with length $($length)"
$body = New-RandomPassword -Length $length
#$body = "This HTTP triggered function executed successfully. Pass a length in the query string or in the request body for a personalized response."

if ($length) 
{
    Write-Host "Generate random password with length $($length)"
    $body = New-RandomPassword -Length $length
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
