Function Set-PDKGithubCredential {
    [CmdletBinding(DefaultParameterSetName='Basic')]
    [OutputType([Void])]
    Param(
        [Parameter(ParameterSetName='Basic', Mandatory=$True, Position=0)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(ParameterSetName='Token', Mandatory=$True, Position=0)]
        [String]$Token,

        [parameter(Mandatory = $False)]
        [Switch]$PassThru
    )

    switch ($PSCmdlet.ParameterSetName) {

        # Basic Authentication
        Basic {
            $AuthString = "{0}:{1}" -f $Credential.Username,(Get-PDKPlainPassword -SecureString $Credential.Password)
            $AuthBytes  = [System.Text.Encoding]::Ascii.GetBytes($AuthString)
            $AuthBase64 = [Convert]::ToBase64String($AuthBytes)
            $Script:GithubAuthorization = "Basic $AuthBase64"
        }

        # Token Authentication
        Token {
            $Script:GithubAuthorization = "Token $Token"
        }
    }

    # Return GithubAuthorization if PassThru is defined
    if ($PassThru) { return $Script:GithubAuthorization }
}