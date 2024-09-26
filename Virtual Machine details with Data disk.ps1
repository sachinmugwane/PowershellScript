$report = @()
    $vms = Get-AzVM
    foreach ($vm in $vms) { 
        $info = "" | Select VmName, ResourceGroupName, Region, VmSize, OsType, Cores, Memory, OSDiskSize, DataDisksSizeinGB
            [string]$sku = $vm.StorageProfile.ImageReference.Sku
            [string]$os = $vm.StorageProfile.ImageReference.Offer
            $osDiskName = $vm.StorageProfile.OsDisk.Name
            $info.VMName = $vm.Name
			$vmLocation = $vm.location 			
            $info.OsType = $os + " " + $sku
            $info.ResourceGroupName = $vm.ResourceGroupName
            $info.VmSize = $vm.HardwareProfile.VmSize
            $sizeDetails = Get-AzVMSize -Location $vmLocation | where {$_.Name -eq $vm.HardwareProfile.VmSize}
            $info.Cores = $sizeDetails.NumberOfCores
            $info.Memory = $sizeDetails.MemoryInMB
			$disk = Get-AzDisk -DiskName $osDiskName -ResourceGroupName $vm.ResourceGroupName
			$info.OSDiskSize = $disk.DiskSizeGB
            if ($vm.StorageProfile.DataDisks.Count -gt 0) {
                $disksum = $vm.StorageProfile.dataDisks.diskSizeGB | foreach { $_ }
            $info.DataDisksSizeinGB = $disksum
            }
            
            $report+=$info
            }
$report | ft VmName, ResourceGroupName, Region, VmSize, OsType, Cores, Memory, OSDiskSize, DataDisksSizeinGB