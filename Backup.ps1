﻿<# 
	This PowerShell script was automatically converted to PowerShell Workflow so it can be run as a runbook.
	Specific changes that have been made are marked with a comment starting with “Converter:”
#>


#workflow BackupReport {
	
	# Converter: Wrapping initial script in an InlineScript activity, and passing any parameters for use within the InlineScript
	# Converter: If you want this InlineScript to execute on another host rather than the Automation worker, simply add some combination of -PSComputerName, -PSCredential, -PSConnectionURI, or other workflow common parameters (http://technet.microsoft.com/en-us/library/jj129719.aspx) as parameters of the InlineScript
	#inlineScript {
		#$connectionName="AzureRunAsConnection"
    	#	$servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         
		
		# Now you can login to Azure PowerShell with your Service Principal and Certificate
		
		#Connect-AzureAD -TenantId $servicePrincipalConnection.TenantId -ApplicationId $servicePrincipalConnection.ApplicationId -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
		
	#	$Conn = Get-AutomationConnection -Name AzureRunAsConnection 
       Set-AzContext -SubscriptionName "SuperApp"
		
		#Collecing Azure virtual machine Information
		Write-Output "Collecting Azure virtual machine information"
		
		$vms = Get-AzVM
		
		#Collecting all Backup Recovery Vault information
		Write-Output "Collecting all Backup Recovery Vault information"
		$backupVaults = Get-AzRecoveryServicesVault
		
		$vmBackupReport = [System.Collections.ArrayList]::new()
		
		foreach ($vm in $vms) {
    		$recoveryVaultInfo = Get-AzRecoveryServicesBackupStatus -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Type 'AzureVM'
		
    		if ($recoveryVaultInfo.BackedUp -eq $true) {
        		Write-Output "$($vm.Name) - BackedUp : Yes"
        		# Backup Recovery Vault Information
        		$vmBackupVault = $backupVaults | Where-Object { $_.ID -eq $recoveryVaultInfo.VaultId }
		
        		# Backup recovery Vault policy Information
        		$container = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM -VaultId $vmBackupVault.ID -FriendlyName $vm.Name
        		$backupItem = Get-AzRecoveryServicesBackupItem -Container $container -WorkloadType AzureVM -VaultId $vmBackupVault.ID
    		}
    		else {
        		Write-Output "$($vm.Name) - BackedUp : No"
        		$vmBackupVault = $null
        		$container = $null
        		$backupItem = $null
    		}
		
    		[void]$vmBackupReport.Add([PSCustomObject]@{
        		VM_Name = $vm.Name
        		VM_Location = $vm.Location
        		VM_ResourceGroupName = $vm.ResourceGroupName
        		VM_BackedUp = $recoveryVaultInfo.BackedUp
        		VM_RecoveryVaultName = $vmBackupVault.Name
        		VM_RecoveryVaultPolicy = $backupItem.ProtectionPolicyName
        		VM_BackupHealthStatus = $backupItem.HealthStatus
        		VM_BackupProtectionStatus = $backupItem.ProtectionStatus
        		VM_LastBackupStatus = $backupItem.LastBackupStatus
        		VM_LastBackupTime = $backupItem.LastBackupTime
        		VM_BackupDeleteState = $backupItem.DeleteState
        		VM_BackupLatestRecoveryPoint = $backupItem.LatestRecoveryPoint
        		RecoveryVault_ResourceGroupName = $vmBackupVault.ResourceGroupName
        		RecoveryVault_Location = $vmBackupVault.Location
    		})
		}
		
		#$vmBackupReport | Export-Csv -Path "$Env:TEMP/AutomationFile.csv" -NoTypeInform
		
		$vmBackupReport | Export-Csv -Path "C:\Reports\SuperApp.csv" -NoTypeInformation
		
		#$Context = New-AzStorageContext -StorageAccountName "test251" -StorageAccountKey "?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2023-05-30T14:23:35Z&st=2023-05-30T06:23:35Z&spr=https&sig=kEsqWiLLougUZxIoNDVbDNW0G4ltq1HuBAoFSWDfpPA%3D"
		#Set-AzStorageBlobContent -Container "test1" -File "$Env:TEMP/AutomationFile.csv" -Blob "backup.csv" -Context $Context
		
	
