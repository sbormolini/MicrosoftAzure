<#
.Synopsis
   Get-AuthenticationBearerToken
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>

function Get-AuthenticationBearerToken
{
    param 
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $TenantId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ClientId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ClientSecret
    )

    # Obtain a bearer token used to authenticate
    $scope = [System.Web.HttpUtility]::UrlEncode("https://monitor.azure.com//.default")   
    $body = "client_id=$ClientId&scope=$scope&client_secret=$ClientSecret&grant_type=client_credentials"
    $headers = @{"Content-Type" = "application/x-www-form-urlencoded" }
    $uri = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"

    try 
    {
        $response = Invoke-RestMethod -Uri $uri -Method "Post" -Headers $headers -Body $body 
        if ($response.StatusCode -lt 300)
        {
            $bearerToken = $response.access_token
        }
        else 
        {
            throw $response.StatusCode
        }
    }
    catch 
    {
        {1:<#Do this if a terminating exception happens#>}
        $bearerToken = $null
    }

    return $bearerToken 
}