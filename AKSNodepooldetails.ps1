

# Get a list of all subscriptions
$subscriptions = Get-AzSubscription

# Initialize an array to store node pool details
$nodePoolDetails = @()

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Set the current subscription
    Set-AzContext -Subscription $subscription

    # Get AKS clusters in the current subscription
    $aksClusters = Get-AzAkscluster

    # Loop through each AKS cluster
    foreach ($aksCluster in $aksClusters) {
        # Get node pool details for the current cluster
        $nodePools = Get-AzAksNodePool -ResourceGroupName $aksCluster.ResourceGroupName -ClusterName $aksCluster.Name

        # Loop through each node pool
        foreach ($nodePool in $nodePools) {
            $nodePoolDetail = [PSCustomObject]@{
                'Cluster Name' = $aksCluster.Name
                'Resource Group' = $aksCluster.ResourceGroupName
                'Kubernetes Version' = $nodePool.OrchestratorVersion
                'Location' = $nodePool.location
                'Subscription' = $nodePool.SubscriptionName
                'NodePool Name' = $nodePool.Name
                'NodePool Size' = $nodePool.VmSize
                'Min Nodes' = $nodePool.MinCount
                'Max Nodes' = $nodePool.MaxCount
                'Max Pods Per Node' = $nodePool.MaxPods

            }

            # Add the node pool detail to the array
            $nodePoolDetails += $nodePoolDetail
        }
    }
}

# Output the node pool details
$nodePoolDetails | Format-Table -AutoSize
