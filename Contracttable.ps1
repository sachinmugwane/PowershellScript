

# Set the Azure context to your subscription

Set-AzContext -SubscriptionId "686af847-7b8d-47fa-88dd-b085fb0bb9d9"

# Set the resource group and VMSS name variables

$resourceGroupName = "MC_BFL-3in1MicroservicesGroup-Prod_3in1-Prod-k8MicroServices_centralindia"

$vmssName = "aks-userpool01-27199026-vmss"

# Get the VMSS instances

$vmssInstances = Get-AzVmssVM -ResourceGroupName $resourceGroupName -VMScaleSetName $vmssName | Select-Object -ExpandProperty InstanceId

# Initialize an empty array to store results

$results = @()

 

# Iterate through VMSS instances

foreach ($InstanceId in $vmssInstances) {

    # Execute command on the VM instance

    $output = Invoke-AzVmssVMRunCommand -ResourceGroupName $resourceGroupName -VMScaleSetName $vmssName -InstanceId $InstanceId -CommandId 'RunShellScript' -ScriptString 'cat /proc/sys/net/netfilter/nf_conntrack_count; cat /etc/hostname'

    

    # Get the output message

    $outputMessage = $output.Value[0].Message

    

    # Split the output by line and select lines 3 and 4

    $outputLines = $outputMessage -split '\n'

    $result = $outputLines[2], $outputLines[3]

    

    # Add the result to the results array

    $results += $result

}

 

# Display the results

$results

