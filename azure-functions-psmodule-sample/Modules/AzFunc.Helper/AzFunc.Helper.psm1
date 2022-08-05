# Import Classes
if (Test-Path "$PSScriptRoot\Classes\classes.psd1") 
{
    $ClassLoadOrder = Import-PowerShellDataFile -Path "$PSScriptRoot\Classes\classes.psd1" -ErrorAction SilentlyContinue
}

foreach ($class in $ClassLoadOrder.order) 
{
    $path = '{0}\classes\{1}.ps1' -f $PSScriptRoot, $class
    if (Test-Path $path) 
    {
        . $path
    }
}

# Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the files
foreach ($import in @($Public + $Private))
{
    try
    {
        Write-Verbose "Importing $($Import.FullName)"
        . $import.fullname
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename