<#
.Synopsis
   Short description
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

function New-RandomPassword 
{
   param 
   (
      [Parameter(Mandatory)]
      [ValidateRange(4,[int]::MaxValue)]
      [int] $Length,
      [int] $Upper = 1,
      [int] $Lower = 1,
      [int] $Numeric = 1,
      [int] $Special = 1
   )

   if ($Upper + $Lower + $Numeric + $Special -gt $Length) 
   {
      throw "number of upper/lower/numeric/special char must be lower or equal to length"
   }

   $uCharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   $lCharSet = "abcdefghijklmnopqrstuvwxyz"
   $nCharSet = "0123456789"
   $sCharSet = "/*-+,!?=()@;:._"
   $charSet = ""
   if($Upper -gt 0) { $charSet += $uCharSet }
   if($Lower -gt 0) { $charSet += $lCharSet }
   if($Numeric -gt 0) { $charSet += $nCharSet }
   if($Special -gt 0) { $charSet += $sCharSet }
   
   $charSet = $charSet.ToCharArray()
   $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
   $bytes = New-Object byte[]($Length)
   $rng.GetBytes($bytes)

   $result = New-Object char[]($Length)
   for ($i = 0 ; $i -lt $Length ; $i++) 
   {
      $result[$i] = $charSet[$bytes[$i] % $charSet.Length]
   }
   $password = (-join $result)
   $valid = $true
   if ($Upper   -gt ($password.ToCharArray() | 
      Where-Object {$_ -cin $uCharSet.ToCharArray() }).Count) 
   { 
      $valid = $false 
   }
   if ($Lower   -gt ($password.ToCharArray() | 
      Where-Object {$_ -cin $lCharSet.ToCharArray() }).Count) 
   { 
      $valid = $false 
   }
   if ($Numeric -gt ($password.ToCharArray() | 
      Where-Object {$_ -cin $nCharSet.ToCharArray() }).Count) 
   { 
      $valid = $false 
   }
   if ($Special -gt ($password.ToCharArray() | 
      Where-Object {$_ -cin $sCharSet.ToCharArray() }).Count) 
   { 
      $valid = $false 
   }

   if(-not$valid) 
   {
      $parameters = @{
         Length = $Length 
         Upper = $Upper 
         Lower = $Lower
         Numeric = $Numeric
         Special = $Special
      }
      $password = New-RandomPassword @parameters
   }

   return $password
}