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
   [CmdletBinding(DefaultParameterSetName = "ClientCredentials")]
   param 
   (
      [Parameter(Mandatory=$true, ParameterSetName="ClientCredentials")]
      [Parameter(Mandatory=$true, ParameterSetName="Token")]
      [ValidateNotNullOrEmpty()]
      [string] $DataCollectionEndpointURI,

      [Parameter(Mandatory=$true, ParameterSetName="ClientCredentials")]
      [Parameter(Mandatory=$true, ParameterSetName="Token")]
      [ValidateNotNullOrEmpty()]
      [string] $DataCollectionRuleImmutableId,
      
      [Parameter(Mandatory=$true, ParameterSetName="ClientCredentials")]
      [Parameter(Mandatory=$true, ParameterSetName="Token")]
      [ValidateNotNullOrEmpty()]
      [string] $TableName,

      [Parameter(Mandatory=$true, ParameterSetName="ClientCredentials")]
      [Parameter(Mandatory=$true, ParameterSetName="Token")]
      [ValidateNotNullOrEmpty()]
      [object] $LogObject,

      [Parameter(Mandatory=$false, ParameterSetName="ClientCredentials")]
      [ValidateNotNullOrEmpty()]
      [string] $TenantId,

      [Parameter(Mandatory=$false, ParameterSetName="ClientCredentials")]
      [ValidateNotNullOrEmpty()]
      [string] $ClientId,

      [Parameter(Mandatory=$false, ParameterSetName="ClientCredentials")]
      [ValidateNotNullOrEmpty()]
      [string] $ClientSecret,

      [Parameter(Mandatory=$false, ParameterSetName="Token")]
      [ValidateNotNullOrEmpty()]
      [string] $Token
   )

   if ($PSCmdlet.ParameterSetName -eq "ClientCredentials") 
   {
       # Obtain a bearer token used to authenticate against the data collection endpoint
      $bearerToken = Get-AuthenticationBearerToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
      if ($null -eq $bearerToken)
      {
         throw "Could not authenticate to tenant $($TenantId). Bearer token is null!"
      }
   }
   else 
   {
      $bearerToken = $Token
   }
   
   # Sending the data to Log Analytics via the DCR!
   $headers = @{
      "Authorization" = "Bearer $bearerToken"
      "Content-Type" = "application/json"
   }
   #$uri = "$($DataCollectionEndpointURI)/dataCollectionRules/$($DataCollectionRuleImmutableId)/streams/$($TableName)?api-version=2021-11-01-preview"
   $uri = $DataCollectionEndpointURI + "/dataCollectionRules/" + $DataCollectionRuleImmutableId + "/streams/Custom-" + $TableName + "?api-version=2021-11-01-preview"
   $uploadResponse = Invoke-RestMethod -Uri $uri -Method "Post" -Headers $headers -Body $LogObject 

   return $uploadResponse
}