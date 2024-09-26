$subscriptionNames = @("BajajPay_core_PROD","BajajPay_Middle_PROD","BajajPay_Middle_UAT")


$subscriptions = Get-AzSubscription | Where-Object { $subscriptionNames -contains $_.Name }


# Initialize an array to store the unattached disks
$unattachedDisks = @()

# Loop through each subscription and fetch the unattached disks
foreach ($subscription in $subscriptions) {
Set-AzContext -Subscription $subscription.Id
$disks = Get-AzDisk | Where-Object { $_.ManagedBy -eq $null }
$unattachedDisks += $disks
}



# Display the unattached disks
$unattachedDisks | Format-Table -Property Name, ResourceGroupName, TimeCreated, Location, DiskSizeGB, DiskState 