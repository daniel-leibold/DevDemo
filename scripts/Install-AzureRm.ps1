<# Clean install #>
<# $env:PSModulePath analysieren und alle verzeichnisse mit Azure löschen #>
<# danach sollte Install-Moduel AzureRM sauber und ohne Fehler ausgeführt werden können #>
<# weitere Infos https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps?view=azurermps-4.1.0 #>

Install-Module AzureRM
Get-Module AzureRM -list | Select-Object Name,Version,Path
Login-AzureRmAccount 

<#

Name     : Azure Demo by Daniel Leibold
Id       : 121fa79d-12ba-4b75-a24d-04f7fcd4fbc8
TenantId : 2e985a54-779b-4d00-8271-6bfabb1e7af9
State    : Enabled
#>

# Select Azure Demo by Daniel Leibold
Select-AzureRmSubscription -SubscriptionId "121fa79d-12ba-4b75-a24d-04f7fcd4fbc8" -verbose
Write-host "Show ressources..."
get-AzureRmResource
Write-Host "Done!"


