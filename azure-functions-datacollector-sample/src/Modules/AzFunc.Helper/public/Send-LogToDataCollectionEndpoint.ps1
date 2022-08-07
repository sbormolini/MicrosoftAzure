<#
.Synopsis
   Send-LogToDataCollectionEndpoint
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

function Send-LogToDataCollectionEndpoint
{
   param 
   (
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [Parameter(Mandatory)]
      [string] $DataCollectionEndpointURI,

      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string] $DataCollectionRuleImmutableId,
      
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string] $TableName,

      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [object] $LogObject,

      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string] $TenantId,

      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [Parameter(Mandatory)]
      [string] $ClientId,

      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string] $ClientSecret
   )

   # Obtain a bearer token used to authenticate against the data collection endpoint
   $bearerToken = Get-AuthenticationBearerToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
   if ($null -eq $bearerToken)
   {
      throw "Could not authenticate to tenant $($TenantId). Bearer token is null!"
   }
   
   # Sending the data to Log Analytics via the DCR!
   $headers = @{
      "Authorization" = "Bearer $bearerToken"; 
      "Content-Type" = "application/json" 
   }
   $uri = "$DataCollectionEndpointURI/dataCollectionRules/$DataCollectionRuleImmutableId/streams/Custom-$TableName?api-version=2021-11-01-preview"
   $uploadResponse = Invoke-RestMethod -Uri $uri -Method "Post" -Body $LogObject -Headers $headers;

   return $uploadResponse
}