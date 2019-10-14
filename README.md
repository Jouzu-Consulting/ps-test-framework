# Testing Framework

This set of scripts and helpers will be the framework used for testing all PowerShell scripts added to the repositories

## Markdown testing

Using MarkdownLint, as a command line interface, I will validate the Markdown files to ensure that they follow the common guidelines for formatting. Rules can be added and removed from testing by modifying the \tests\.markdownlint.json file.

## PowerShell

Using a combination of Pester and PowerShell Script Analyzer, under the tests\Unit folder is a psAnalyzer.Tests.ps1 file. This can be called with Invoke-Pester to search through all the PS1 & PSD files in your folder and then run the Script Analyzer rules against them.

Configuration of PSSA can be done using the PSScriptAnalyzerSettings.psd1 in the tests folder.

In the Azure Pipeline configuration, I run the following code:

```powershell
Invoke-Pester .\tests\Unit\psAnalyzer.Tests.ps1 -OutputFile TEST-Pester.XML -OutputFormat NUnitXML -EnableExit
```

This runs the Pester tests, outputs the results to an XML file which can be published as test results and returns an exit code so that the build actually fails when Pester tests fail.

## Pipeline configurations

Within the Pipeline folder, I have configurations for running against certain build/pipeline services.

- AzureDevOpsPipeline.yaml
YAML file that is used to configure an Azure DevOps Pipeline.
  - Contains a task to install MarkdownLint
  - Runs MarkdownLint using the settings under tests\.markdownlint.json
  - Runs the helpers\ConfigureEnvironment.ps1 script to ensure all required modules are installed, along with setting the environment variable for working with custom modules.
  - Runs Invoke-Pester, calls the test script in tests\Unit\psAnalyzer.ps1. Outputs the test results to a NUnit XML file which can be reported on in Azure DevOps
  - Runs a task to import the XML file generated on the previous step. This gives a nice graph and reporting of the build status.
