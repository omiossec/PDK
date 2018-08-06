# +++++++++++++++++++++++++++++++++++++++
# Set Variable
$Script:ModuleRoot = $PSScriptRoot

# +++++++++++++++++++++++++++++++++++++++
# Get powershell files
$Public = @( Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1")
$Private = @( Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1")

# +++++++++++++++++++++++++++++++++++++++
# Import file
@($Public + $Private) | ForEach-Object {
    Try {
        Write-Verbose "Load $($_.FullName)"
        . $_.FullName
    }
    Catch {
        write-Error -Message "Failed to import function $($_.FullName): $($_.Exception.Message)"
    }
}
