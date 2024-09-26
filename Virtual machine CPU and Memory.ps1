 

# Initialize an array to store VM details

$vmDetails = @()

# Get all subscriptions

$subscriptions = Get-AzSubscription

foreach ($subscription in $subscriptions) {

    # Select the current subscription

    Select-AzSubscription -SubscriptionId $subscription.Id

    # Get VM details for the current subscription

    $vms = Get-AzVM

    foreach ($vm in $vms) {

        # Get VM size

        $vmsize = $vm.HardwareProfile.VmSize

        # Get VM size details

        $vmSizeDetails = Get-AzVMSize -VMName $vm.Name -ResourceGroupName $vm.ResourceGroupName | Where-Object { $_.Name -eq $vmsize }

        # Extract VM details

        $vmDetail = [PSCustomObject]@{

            VMName    = $vm.Name

            CPU       = $vmSizeDetails.NumberOfCores

            MemoryGB  = $vmSizeDetails.MemoryInMB / 1024

        }

        # Add VM details to the array

        $vmDetails += $vmDetail

    }

}

# Export VM details to Excel

$vmDetails | Export-Csv -Path "AzureVM_Details.csv" -NoTypeInformation