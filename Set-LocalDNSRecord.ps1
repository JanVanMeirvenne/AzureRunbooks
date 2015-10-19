param(
		[string] $Record,
		[string] $Zone,
		[string] $Type = 'A',
		[string] $IP
	)

$Cred = Get-AutomationPSCredential -Name 'On-prem Admin'
$Computer = Get-AutomationVariable -Name 'DNS-Server'

invoke-command -ComputerName $Computer -Credential $Cred -ScriptBlock {
	
		$Record = $args[0],
		$Zone = $args[1],
		$Type = $args[2],
		$IP = $args[3]
	
	import-module dnsserver
	$NewObj = Get-DnsServerResourceRecord -Name $Record -ZoneName $Zone -RRType $Type
	$OldObj = Get-DnsServerResourceRecord -Name $Record -ZoneName $Zone -RRType $Type
	$NewObj.RecordData.IPv4Address = $IP
	Set-DnsServerResourceRecord -NewInputObject $NewObj -OldInputObject $OldObj -ZoneName $Zone
	
} -ArgumentList $Record,$Zone,$Type,$IP