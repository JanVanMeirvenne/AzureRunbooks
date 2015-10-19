workflow Failover-NewKid
{
    param (
        [Object]$RecoveryPlanContext
    )

	 #Read the VM GUID from the context
    $VM = $RecoveryPlanContext.VmMap.$VMGUID

    if ($VM -ne $null)
    {
        # Invoke pipeline commands within an InlineScript
		
        $EndpointStatus = InlineScript {
            # Invoke the necessary pipeline commands to add a Azure Endpoint to a specified Virtual Machine
            # This set of commands includes: Get-AzureVM | Add-AzureEndpoint | Update-AzureVM (including necessary parameters)
			Connect-Azure
            $Item = Get-AzureVM -ServiceName $Using:VM.CloudServiceName -Name $Using:VM.RoleName
            $Item|Add-AzureEndpoint -Name "NewKidWebsite" -Protocol "TCP" -PublicPort '80' -LocalPort '80'
			$Item|Add-AzureEndpoint -Name "NewKidRDP" -Protocol "TCP" -PublicPort '3389' -LocalPort '3389'
            $Item|Update-AzureVM
			CheckPoint
			$IP = $Item.IPAddress
			Set-NamecheapDNSRecord -IP $IP -Record 'NewKid'
			CheckPoint
			$params = @{"Zone"="JVM-NET.COM";"Record"="NewKid";"IP"=$IP}
			Start-AzureAutomationRunbook –AutomationAccountName "jvm-net-sma" –Name "Set-LocalDNSRecord" –Parameters $params -RunOn 'Azure01'
            Write-Output $Status
        }
    }
}