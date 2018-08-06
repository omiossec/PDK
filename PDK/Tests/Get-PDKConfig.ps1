# Import PesterHelper class
. (Join-Path -Path $PSScriptRoot -ChildPath 'PesterHelper.class.ps1')

# Load PesterHelper Environment
$PesterHelper = [PesterHelper]::new()
$PesterHelper.ImportModule()


# Pester Tests
Describe 'Test Get-PDKConfig' {

    It 'Should be get configuration using Key parameter' {
        $Config = Get-PDKConfig -Key Github
        $Config | Should -BeOfType System.Object
        $Config.API_URI | Should -Be "https://api.github.com"
    }

    It 'Should be get configuration using Key and Sub parameter' {
        $Config = Get-PDKConfig -Key Github -SubKey API_URI
        $Config | Should -BeOfType System.String
        $Config | Should -Be "https://api.github.com"
    }
}

# Unload PesterHelper
$PesterHelper.RemoveModule()