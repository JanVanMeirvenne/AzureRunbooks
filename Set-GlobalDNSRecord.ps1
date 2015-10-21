workflow Set-GlobalDNSRecord
{
	param(
		[String] $Record,
		[String] $WANIP,
		[String] $LANIP = "127.0.0.1"
	)
	
	if($WANIP -eq $null){
		write-verbose 'WAN parameter empty, obtaining public ip for this machine'
		$WANIP = Get-PublicIP
		write-debug "WAN IP Detected: $WANIP"
	}
	
		Set-NamecheapDNSRecord -IP $WANIP -Record 'NewKid'
		Set-LocalDNSRecordWF -Record 'NewKid' -IP $LANIP
	
	
	 
}