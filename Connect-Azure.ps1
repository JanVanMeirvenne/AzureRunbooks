workflow Connect-Azure
{
	Add-AzureAccount -Credential (Get-AutomationPSCredential -name 'Azure')
	
}