<#
    .SYNOPSIS
    Script to go through and run pester tests wherever possible
#>

$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$script:globalRoot = Split-Path -Parent $script:moduleRoot
$psScripts = Get-ChildItem $script:moduleRoot -Filter '*.ps1' -Recurse | Where-Object {$_.FullName -notmatch 'ps-test-framework'}
$unitTests = $psScripts | Where-Object { $_.FullName -match '\\Unit\\' }


foreach ($unitTest in $unitTests)
{
    $unitTestFullPath = $unitTest.FullName
    $unitTestName = $unitTest.Name
    $unitTestName = $unitTestName.TrimEnd('.Tests.ps1')

    $scriptToTest = $psScripts | Where-Object { $_.FullName -notmatch '\\unit\\' -and $_.Name -match $unitTestName }

    Invoke-Pester $unitTestFullPath -CodeCoverage $scriptToTest.FullName
}