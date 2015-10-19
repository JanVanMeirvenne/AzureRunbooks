workflow Monitor-OMS
{
$OMSCon = Get-AutomationConnection -Name 'Connection_OMS'
$Token = Get-AADToken -OMSConnection $OMSCon
$subscriptionId = '2acf83f0-fd90-4172-9478-764dd31b80a8'
$ResourceGroupName = 'mms-weu'
$OMSWorkspace = 'JVM-NET'
$Query = 'Type=Event EventLog=System | Select TimeGenerated,Computer'

Invoke-OMSSearchQuery -SubscriptionID $subscriptionId -ResourceGroupName $ResourceGroupName -OMSWorkspaceName $OMSWorkspace -Query $Query -Token $Token


}