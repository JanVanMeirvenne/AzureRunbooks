workflow WebHookDemo
{
	[OutputType([string])]
	param(
		[object] $WebhookData
	)
	
	 $WebhookName    =   $WebhookData.WebhookName
     $WebhookHeaders =   $WebhookData.RequestHeader
     $WebhookBody    =   $WebhookData.RequestBody
	 
	 $Data = ConvertFrom-Json -InputObject $WebhookBody
	 
	 $Output = Set-NamecheapDNSRecord -Record $Data.Record
	 write-output "Data received from $($WebhookHeaders.From): Input: Record = $($Data.Record)|Output: $($Output)"
	 
}