<# 
# Import Classes by Order
if (Test-Path -Path "$PSScriptRoot\Classes\classes.psd1") 
{
    $classLoadOrder = Import-PowerShellDataFile -Path "$PSScriptRoot\Classes\classes.psd1" -ErrorAction SilentlyContinue
}

foreach ($class in $classLoadOrder.order) 
{
    $path = '{0}\classes\{1}.ps1' -f $PSScriptRoot, $class
    if (Test-Path -Path $path) 
    {
        . $path
    }
}
#>

# Import Classes
$classes = Get-ChildItem -Path $PSScriptRoot\classes\*.ps1 -ErrorAction SilentlyContinue
foreach ($class in $classes) 
{
    if (Test-Path -Path $class.FullName) 
    {
        Write-Verbose "Importing $($class.FullName)"
        . $class.FullName
    }
}

# Get public and private function definition files.
$publicFunctions = @(Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue)
$privateFunctions = @(Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue)

# Dot source the files
foreach ($import in @($publicFunctions + $privateFunctions))
{
    try
    {
        Write-Verbose "Importing $($import.FullName)"
        . $import.fullname
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $publicFunctions.Basename