<#
    .SYNOPSIS
    Script to run through using Pester and test all is healthy.
#>

$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$script:globalRoot = Split-Path -Parent $script:moduleRoot
$psAnalyzerSettings = "$script:moduleRoot\Tests\PSScriptAnalyzerSettings.psd1"
$psScripts = Get-ChildItem $script:globalRoot -Filter '*.ps1' -Recurse | Where-Object {$_.Name -notmatch 'Tests.ps1'}
$psModules = Get-ChildItem $script:globalRoot -Filter '*.psm1' -Recurse

Describe "when testing all scripts with PowerShell with PSScriptAnalyzer" {
    foreach ($psScript in $psScripts)
    {
        Context "when testing PowerShell script - $($psScript.BaseName)" {
            $analysis  = Invoke-ScriptAnalyzer -Path $psScript.FullName -EnableExit -Settings $psAnalyzerSettings
            $scriptAnalyzerRules = Get-ScriptAnalyzerRule

            forEach ($rule in $scriptAnalyzerRules) {
                It "it should pass $rule" {
                    If ($analysis.RuleName -contains $rule) {
                        $analysis |
                            Where-Object RuleName -EQ $rule -outvariable failures |
                            Out-Default
                        $failures.Count | Should -Be 0
                    }
                }
            }
        }
    }
}

Describe "when testing all modules with PowerShell with PSScriptAnalyzer" {
    foreach ($psModule in $psModules)
    {
        Context "when testing PowerShell module - $($psModule.BaseName)" {
            $analysis  = Invoke-ScriptAnalyzer -Path $psModule.FullName -EnableExit -Settings $psAnalyzerSettings
            $scriptAnalyzerRules = Get-ScriptAnalyzerRule

            forEach ($rule in $scriptAnalyzerRules) {
                It "it should pass $rule" {
                    If ($analysis.RuleName -contains $rule) {
                        $analysis |
                            Where-Object RuleName -EQ $rule -outvariable failures |
                            Out-Default
                        $failures.Count | Should -Be 0
                    }
                }
            }
        }
    }
}