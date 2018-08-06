Function Get-Config {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False, Position=0)]
        [String]$Key,

        [Parameter(Mandatory=$False, Position=1)]
        [String]$SubKey
    )

    # Get user configuration path
    $ConfigPath = Join-Path -Path ([Environment]::GetFolderPath("mydocuments")) -ChildPath 'WindowsPowerShell\pdk_config.json'
    if((Test-Path -Path $ConfigPath) -eq $False){
        $ConfigPath = Join-Path -Path $Script:ModuleRoot -ChildPath 'config.json'
    }

    # Load configuration
    Try {
        $ConfigJson   = Get-Content -Path $ConfigPath -Raw
        $ConfigObject = $ConfigJson | ConvertFrom-Json
    } Catch {
        Write-Error "Provided Configuration file is not a valid JSON"
    }

    # Return Value
    if(([string]::IsNullOrEmpty($Key)) -eq $False) {
        if(([string]::IsNullOrEmpty($SubKey)) -eq $False) {
            return $ConfigObject.($Key).($SubKey)
        } else {
            return $ConfigObject.($Key)
        }
    } else {
        return $ConfigObject
    }
}