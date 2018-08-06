Class PesterHelper {

    [String]$CurrentLocation                    # Current location
    [Object]$MainModuleInformation              # Main module object Information
    [String]$MainModuleName                     # Main module nale
    [String]$MainModuleManifest                 # Main module manifest file
    [System.Collections.ArrayList]$ModuleLoaded # List of imported modules
    [String]$TmpDirectory                       # Tmp location to exucute test

    PesterHelper() {
        $this.CurrentLocation    = Get-Location
        $this.ModuleLoaded       = New-Object System.Collections.ArrayList
    }

    [String] GetMainModuleDirectory(){
        return (get-item -Path $PSScriptRoot).parent.FullName
    }

    [String] GetMainModuleManifest(){
        return  (Get-ChildItem -Path "$($this.GetMainModuleDirectory())\*.psd1").FullName
    }

    Hidden [Bool] ModuleIsLoaded([String]$ModuleName){
        if(Get-Module -Name $ModuleName) {
            return $True
        } else {
            return $False
        }
    }

    [Void] ImportModule([String]$ModuleName) {
        Microsoft.PowerShell.Core\Import-Module -Name $ModuleName
        $this.ModuleLoaded.Add($ModuleName)
    }

    [Void] ImportModule() {
        Write-Debug "Import main module - $($this.GetMainModuleManifest())"
        $this.MainModuleInformation = Microsoft.PowerShell.Core\Import-Module $this.GetMainModuleManifest() -Global -PassThru
        $this.MainModuleName = $this.MainModuleInformation.Name
        $this.ModuleLoaded.Add($this.MainModuleName)
    }

    [Void] RemoveModule([String]$ModuleName) {
        if($this.ModuleIsLoaded($ModuleName)) {
            Microsoft.PowerShell.Core\Remove-Module -Name $this.ModuleName
            $this.ModuleLoaded.Remove($ModuleName)
        } else {
            write-warning "Can not delete $ModuleName module because it is not imported"
        }
    }

    [Void] RemoveModule() {
        Write-Debug "Remove Module - $($this.MainModuleName)"
        if($this.ModuleIsLoaded($this.MainModuleName)) {
            Microsoft.PowerShell.Core\Remove-Module -Name $this.MainModuleName
            $this.ModuleLoaded.Remove($this.MainModuleName)
        } else {
            Write-Warning "Can not delete main module because it is not imported"
        }
    }

    [Void] RemoveAllModule() {
        foreach($ModuleName in $this.ModuleLoaded.Clone()){
            Write-Debug "[PesterHelper] Remove Module - $ModuleName"
            if($this.ModuleIsLoaded($ModuleName)) {
                Microsoft.PowerShell.Core\Remove-Module -Name $ModuleName
            } else {
                Write-Warning "Can not delete $ModuleName module because it is not imported"
            }
            $this.ModuleLoaded.Remove($ModuleName)
        }
    }

    [String] CreateTmpDirectory(){
        if([string]::IsNullOrEmpty($this.TmpDirectory)) {
            $Parent = [System.IO.Path]::GetTempPath()
            $Name = [System.IO.Path]::GetRandomFileName()
            $this.TmpDirectory = Join-Path -Path $Parent -ChildPath $Name
            Write-Debug "[PesterHelper][CreateTmpDirectory] Create Temporary folder at $($this.TmpDirectory)"
            New-Item -ItemType Directory -Path $this.TmpDirectory
        }
        return $this.TmpDirectory
    }

    [Void] RemoveTmpDirectory(){
        if([string]::IsNullOrEmpty($this.TmpDirectory) -eq $False) {
            if(Test-Path $this.TmpDirectory) {
                Remove-Item -Path $this.TmpDirectory -Force -Recurse -Confirm:$False
                $this.TmpDirectory = $Null
            } else {
                Write-Error "Unable to find Temporary directory - $($this.TmpDirectory)"
            }
        } else {
            Write-Error "No temporary folder was created"
        }
    }
}
