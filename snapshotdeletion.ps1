# Define the maximum age of snapshots in days

$maxSnapshotAgeInDays = 0

 

Set-AzContext -SubscriptionName  "Rewards_Prod"

 

# Get all snapshots

$snapshots = Get-AzSnapshot | Where-Object { $_.TimeCreated -lt (Get-Date).AddDays(-$maxSnapshotAgeInDays) }

 

# Iterate through each snapshot and delete it

foreach ($snapshot in $snapshots) {

    Remove-AzSnapshot -ResourceGroupName $snapshot.ResourceGroupName -SnapshotName $snapshot.Name -Force

    Write-Output "Snapshot '$($snapshot.Name)' in resource group '$($snapshot.ResourceGroupName)' deleted."

}