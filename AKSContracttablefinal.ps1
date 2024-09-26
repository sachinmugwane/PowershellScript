# Set the Azure context to your subscription
Set-AzContext -SubscriptionId "686af847-7b8d-47fa-88dd-b085fb0bb9d9"

# Set the resource group and VMSS name variables
$resourceGroupName = "MC_BFL-3in1MicroservicesGroup-Prod_3in1-Prod-k8MicroServices_centralindia"
$vmssArray = Get-AzVmss -ResourceGroupName $resourceGroupName

# Initialize an empty array to store results
$results = @()

# Iterate through VMSS instances
foreach ($vmss in $vmssArray) {
    $vmssName = $vmss.Name
    
    # Get VMSS instances
    $vmssInstances = Get-AzVmssVM -ResourceGroupName $resourceGroupName -VMScaleSetName $vmssName | Select-Object -ExpandProperty InstanceId
    
    # Iterate through VMSS VM instances
    foreach ($InstanceId in $vmssInstances) {
        try {
            # Execute command on the VM instance
            $output = Invoke-AzVmssVMRunCommand -ResourceGroupName $resourceGroupName -VMScaleSetName $vmssName -InstanceId $InstanceId -CommandId 'RunShellScript' -ScriptString 'cat /proc/sys/net/netfilter/nf_conntrack_count; cat /etc/hostname'

            # Check if the command was successful
            if ($output.Status -eq "Succeeded") {
                $outputMessage = $output.Value[0].Message
                $outputLines = $outputMessage -split '\n'
                $result = "VMSS Name: $vmssName, Instance ID: $InstanceId", $outputLines[2], $outputLines[3]
                $results += $result
            }
        } catch {
            # Handle any errors here if needed
            Write-Host "Error executing command on VM instance $InstanceId in VMSS $vmssName"
        }
    }
}

# Display the results
$results

