BeforeAll {
    $ModuleManifestName = 'AzFunc.Helper.psd1'
    $ModuleName = 'AzFunc.Helper.psm1'
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
        $manifest.Name | Should -Be "AzFunc.Helper"
        $manifest.ModuleType | Should -Be "Script"
    }
}

Describe 'Module Function Tests' {
    BeforeAll {
        Import-Module $ModulePath -Force
    }
    It 'Passes NewRandomPassword Length 12' {
        $password = New-RandomPassword -Length 12
        $password  | Should -Not -BeNullOrEmpty
        $password.Length | Should -Be 12
    }
}