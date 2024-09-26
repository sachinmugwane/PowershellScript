Connect-AzAccount

# Get a list of all subscriptions
$subscriptions = Get-AzSubscription

# Initialize an array to store AKS cluster details
$aksClusterDetails = @()

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Set the current subscription
    Set-AzContext -Subscription $subscription

    # Get AKS clusters in the current subscription
    $aksClusters = Get-AzAksCluster

    # Loop through each AKS cluster
    foreach ($aksCluster in $aksClusters) {
        # Get the location of the current cluster
        $location = $aksCluster.Location
        $KubernetesVersion = $aksCluster.KubernetesVersion

        # Get node pool details for the current cluster
        $nodePools = Get-AzAksNodePool -ResourceGroupName $aksCluster.ResourceGroupName -ClusterName $aksCluster.Name

        # Loop through each node pool
        foreach ($nodePool in $nodePools) {
            $aksClusterDetail = [PSCustomObject]@{
                'Cluster Name' = $aksCluster.Name
                'Subscription Name' = $subscription.Name
                'Resource Group' = $aksCluster.ResourceGroupName
                'Location' = $location
                'Kubernetes Version' = $KubernetesVersion
                'NodePool Name' = $nodePool.Name
                'NodePool Size' = $nodePool.VmSize
                'Min Nodes' = $nodePool.MinCount
                'Max Nodes' = $nodePool.MaxCount
                'Current Node Count' = $nodePool.Count
                'Max Pods Per Node' = $nodePool.MaxPods
            }

            # Add the AKS cluster detail to the array
            $aksClusterDetails += $aksClusterDetail
        }
    }
}

# Output the AKS cluster details
$aksClusterDetails |  Export-Csv -Path D:\AllAKS.csv -NoTypeInformation
