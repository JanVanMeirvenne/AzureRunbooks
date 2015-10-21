workflow Set-LocalDNSRecordWF
{
	param(
		[string] $Record,
		[string] $Zone = "jvm-net.com",
		[string] $Type = 'A',
		[string] $IP
	)

$Cred = Get-AutomationPSCredential -Name 'On-prem Admin'
$Computer = Get-AutomationVariable -Name 'DNS-Server'

InLineScript {
	
		$Record = $Using:Record
		$Zone = $Using:Zone
		$Type = $Using:Type
		$IP = $Using:IP
	
	import-module dnsserver
	$NewObj = Get-DnsServerResourceRecord -Name $Record -ZoneName $Zone -RRType $Type
	$OldObj = Get-DnsServerResourceRecord -Name $Record -ZoneName $Zone -RRType $Type
	$NewObj.RecordData.IPv4Address = $IP
	Set-DnsServerResourceRecord -NewInputObject $NewObj -OldInputObject $OldObj -ZoneName $Zone
	
} -PsCredential $Cred -PsComputerName $Computer
}