workflow Failover-NewKid
{
    param (
        [Object] $RecoveryPlanContext
    )
    
	if($RecoveryPlanContext -eq $null){
		Write-Error "Recovery Plan Context Not Found"
	} else {
		Write-Verbose $RecoveryPlanContext
	}
	
	$VMGUID = "f30dff0c-a87c-464a-86df-6b6562a139e6"
	
    $VM = $RecoveryPlanContext.VmMap.$VMGUID
	#$VM = ""|select CloudServiceName,RoleName
	#$VM.RoleName = 'RedShirt-test'
	#$VM.CloudServiceName = 'MainToDR-test'
    if($VM -eq $null){
		Write-Error "VM $VMGUID not found in context"
	} else {
		Write-Verbose $VM
	}
	
	 

    if ($VM -ne $null)
    {
		Connect-Azure
		
        # Invoke pipeline commands within an InlineScript

        [String] $IP = InlineScript{
			            # Invoke the necessary pipeline commands to add a Azure Endpoint to a specified Virtual Machine
            # This set of commands includes: Get-AzureVM | Add-AzureEndpoint | Update-AzureVM (including necessary parameters)
			
            $Item = Get-AzureVM -ServiceName $Using:VM.CloudServiceName -Name $Using:VM.RoleName
            $Item|Add-AzureEndpoint -Name "NewKidWebsite" -Protocol "TCP" -PublicPort '80' -LocalPort '80'-EA SilentlyContinue|out-null
			$Item|Update-AzureVM -EA SilentlyContinue|out-null
			$Item|Add-AzureEndpoint -Name "NewKidRDP" -Protocol "TCP" -PublicPort '3389' -LocalPort '3389' -EA SilentlyContinue|out-null
            $Item|Update-AzureVM -EA SilentlyContinue|out-null

			$IP = (Get-AzureDeployment -ServiceName $Using:VM.CloudServiceName -Slot Production).VirtualIPs.Address
			return $IP
		}
        Checkpoint-Workflow
           
        
		Parallel{
			
			Set-NamecheapDNSRecord -IP $IP -Record 'NewKid'
			CheckPoint-Workflow
			InlineScipt{
				$params = @{"Zone"="JVM-NET.COM";"Record"="NewKid";"IP"="$UsingIP"}
				Start-AzureAutomationRunbook –AutomationAccountName "jvm-net-sma" –Name "Set-LocalDNSRecordWF" –Parameters $params -RunOn 'Azure01'|out-null
			}
		}
	}
}