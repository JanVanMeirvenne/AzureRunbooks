workflow Get-PublicIP
{
	[OutputType([string])]
	$IP = Invoke-WebRequest -Uri "http://ifconfig.me/ip" -UseBasicParsing
	write-output $IP.Content
}