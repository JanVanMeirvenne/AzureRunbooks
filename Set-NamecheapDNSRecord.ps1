workflow Set-NamecheapDNSRecord
{
    param(
        [string] $Password,
        [string] $Record,
        [String] $Domain = "jvm-net.com",
        [String] $IP
        
    )
    if($Password -eq $null){
        $Password = Get-AutomationVariable -Name 'JVM-NET Dynamic DNS Namecheap Password'
    }
    $Output = InlineScript{
       $dnshost = $Using:Record
       $dnsdomain = $Using:Domain
       $dnsip = $Using:IP
       $dnspassword = $Using:Password
       $Request = "https://dynamicdns.park-your-domain.com/update?host=$dnshost&domain=$dnsdomain&password=$dnspassword&ip=$dnsip"
       $Result = Invoke-WebRequest -Uri $Request -UseBasicParsing
       $Result
    }

    if($Output.StatusCode -eq 200){
        Write-Output "Record updated succesfully $($Output.Content)"
    } else {
        Write-Error "Record update failed $($Output.Content)"
    
    }
}