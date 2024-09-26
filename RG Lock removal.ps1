# Define your Azure subscription and lock name

Set-AzContext -SubscriptionName  "BajajPay_Prod_P4G"

$lockName = "RG-Lock1"

 
# Get all resource groups in the subscription

$resourceGroups = Get-AzResourceGroup 

 

# Iterate through each resource group and remove the specified lock

foreach ($resourceGroup in $resourceGroups) {

    $lock = Get-AzResourceLock -ResourceGroupName $resourceGroup.ResourceGroupName -LockName $lockName -ErrorAction SilentlyContinue

    if ($lock) {

       
        Remove-AzResourceLock -LockName $lockName -ResourceGroupName $resourceGroup.ResourceGroupName -Force   
        Write-Output "Lock '$lockName' removed from resource group '$($resourceGroup.ResourceGroupName)'."

    } else {

        Write-Output "Lock '$lockName' not found in resource group '$($resourceGroup.ResourceGroupName)'."

    }

}

