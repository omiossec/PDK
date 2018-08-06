function Get-PDKPlainPassword() {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [System.Security.SecureString]$SecureString
    )

    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString);
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr);
    } finally {
        [Runtime.InteropServices.Marshal]::FreeBSTR($bstr);
    }

}