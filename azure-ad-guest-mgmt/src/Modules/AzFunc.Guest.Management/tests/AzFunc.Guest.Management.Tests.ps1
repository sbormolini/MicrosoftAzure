BeforeAll {
    $ModuleManifestName = 'AzFunc.Guest.Management.psd1'
    $ModuleName = 'AzFunc.Guest.Management.psm1'
    if ($PSScriptRoot -eq $null)
    {
        # dev test path
        $ModuleManifestPath = "..\$ModuleManifestName"
        $ModulePath = "..\$ModuleName"
    }
    else
    {
        $ModuleManifestPath = (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath $ModuleManifestName)
        $ModulePath = (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath $ModuleName)
    }
}

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $manifest = Test-ModuleManifest -Path $ModuleManifestPath
        $manifest | Should -Not -BeNullOrEmpty
        $manifest.Name | Should -Be "AzFunc.Guest.Management"
        $manifest.ModuleType | Should -Be "Script"
    }
}