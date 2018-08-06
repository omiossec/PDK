# Import PesterHelper class
. (Join-Path -Path $PSScriptRoot -ChildPath 'PesterHelper.class.ps1')

# Load PesterHelper Environment
$PesterHelper = [PesterHelper]::new()
$PesterHelper.ImportModule()

# Pester Tests
Describe 'Test Set-PDKGithubCredential' {

    It 'Should be set Token Credential' {
        $Credential = Set-PDKGithubCredential -Token "allYourBaseAreBelongToUs!" -PassThru
        $Credential | Should -BeOfType System.String
        $Credential | Should -Be "Token allYourBaseAreBelongToUs!"
    }

    It 'Should be set Basic Credential' {
        # Creade SecureString Credential
        $Username = "LeelooDallas"
        $Password = ConvertTo-SecureString "Multipass" -AsPlainText -Force
        $PSCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $Username, $Password

        $Credential = Set-PDKGithubCredential -Credential $PSCredential -PassThru
        $Credential | Should -BeOfType System.String
        $Credential | Should -Be "Basic TGVlbG9vRGFsbGFzOk11bHRpcGFzcw=="
    }

}

# Unload PesterHelper
$PesterHelper.RemoveModule()