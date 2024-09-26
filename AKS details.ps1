$subscriptionId = "b638e83d-9274-4998-8bac-3a9f39dd7171"

# Set the subscription context to the specified subscription
az account set --subscription $subscriptionId

# Get all the AKS clusters in the subscription
$aksClusters = az aks list --query "[].{name: name, resourceGroup: resourceGroup}" | ConvertFrom-Json

# Create an array to store the details of the AKS clusters
$aksClusterDetails = @()

# Loop through each AKS cluster
foreach ($aksCluster in $aksClusters) {
  # Get the node pools in the AKS cluster
  $nodePools = az aks nodepool list --cluster-name $aksCluster.name --resource-group $aksCluster.resourceGroup | ConvertFrom-Json

  # Loop through each node pool
  foreach ($nodePool in $nodePools) {
    # Store the details of the AKS cluster and node pool in an object
    $aksClusterDetail = [PSCustomObject]@{
      "Cluster Name" = $aksCluster.name
      "Node Pool Name" = $nodePool.name
      "Node Size" = $nodePool.vmSize
      "Max Node Count" = $nodePool.maxCount
      "Min Node Count" = $nodePool.minCount
      "Running Node Count" = $nodePool.count
      "Virtual Network" = $nodePool.vnetSubnetId
      "Subscription Name" = (az account show --query name -o tsv)
    }
    
    # Add the object to the array
    $aksClusterDetails += $aksClusterDetail
  }
}

# Output the details of the AKS clusters
$aksClusterDetails | Select-Object "Cluster Name", "Node Pool Name", "Node Size", "Max Node Count", "Min Node Count", "Running Node Count", "Subscription Name", "Virtual Network" | Format-Table -AutoSize
