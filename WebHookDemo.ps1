workflow WebHookDemo
{
	[OutputType([string])]
	param(
		[object] $WebhookData
	)
	
	 $WebhookName    =   $WebhookData.WebhookName
     $WebhookHeaders =   $WebhookData.RequestHeader
     $WebhookBody    =   $WebhookData.RequestBody
	 $IP = ""
	 $Data = ConvertFrom-Json -InputObject $WebhookBody
	 if($Data.IP -eq $null){
		 Connect-Azure
		 $Job = Start-AzureAutomationRunbook –AutomationAccountName "jvm-net-sma" –Name "Get-PublicIP" -RunOn 'Azure01'
	     $doLoop = $true
		While ($doLoop) {
   			$job = Get-AzureAutomationJob –AutomationAccountName "jvm-net-sma" -Id $job.Id
   			$status = $job.Status
   			$doLoop = (($status -ne "Completed") -and ($status -ne "Failed") -and ($status -ne "Suspended") -and ($status -ne "Stopped"))
		}
		
		$Output = Get-AzureAutomationJobOutput –AutomationAccountName "jvm-net-sma" -Id $job.Id –Stream Output
		$IP = (string) $Output
		} else {
			$IP = $Data.IP	
		}


	 
	 $Output = Set-NamecheapDNSRecord -Record $Data.Record -IP $IP
	 write-output "Data received from $($WebhookHeaders.From): Input: Record = $($Data.Record)|Output: $($Output)"
	 
}