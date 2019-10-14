# Install Required Modules

$ModulesRequired = @(
    'PSScriptAnalyzer',
    'ComputerManagementDsc'
    'PSDscResources'
)

foreach ($ModuleRequired in $ModulesRequired)
{
    $ModuleCheck = Get-Module -ListAvailable | Where-Object {$_.Name -eq $ModuleRequired}
    if(!$ModuleCheck)
    {
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        Install-Module $ModuleRequired -Confirm:$false -Scope CurrentUser
    }
}

# Configure the Module Path for all testing
$parentPath = Split-Path $PSScriptRoot -Parent

if ($env:PSModulePath -notcontains $parentPath)
{
    [System.Environment]::SetEnvironmentVariable('PSModulePath',$env:PSModulePath + ";$parentPath", [System.EnvironmentVariableTarget]::User)
}

# Install Pester, force update to latest version as Windows version won't update.
Install-Module -Name Pester -Force -SkipPublisherCheck
