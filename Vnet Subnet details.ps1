
$outputfinal=@()

Select-AzSubscription -SubscriptionId "686af847-7b8d-47fa-88dd-b085fb0bb9d9"
$nets=Get-AzVirtualNetwork
foreach ($net in $nets)
{
$snets=$net.Subnets
foreach ($snet in $snets)
{
$outputtemp = "" | SELECT  VNET,VNET_AddressSpace,VNET_Location,ResourceGroup,Subnet_Name,Subnet_AddressPrefix
$outputtemp.VNET=$net.Name
$outputtemp.VNET_AddressSpace=$net.AddressSpace.AddressPrefixes.trim('{}')
$outputtemp.VNET_Location=$net.Location
$outputtemp.ResourceGroup=$net.ResourceGroupName
$outputtemp.Subnet_Name=$snet.Name
$outputtemp.Subnet_AddressPrefix=$snet.AddressPrefix.trim('{}')
$outputfinal += $outputtemp
}
}

#$outputfinal | Format-Table
$outputfinal | Export-Csv  -Path "C:\Reports\vnet.csv" -NoTypeInformation 
