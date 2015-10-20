workflow Connect-Azure
{
	Add-AzureAccount -Credential (Get-AutomationPSCredential -name 'Azure')
	Set-AzureSubscription -SubscriptionName "Pay-As-You-Go" ` -CurrentStorageAccountName (Get-AzureStorageAccount).Label -PassThru

	
}