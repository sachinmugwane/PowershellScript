

# Set the storage account context
$storageAccountName = "bflmerchantappsa"
$storageAccountKey = "RrYDURXe20tpNXZgUfLWG0Wa5ptR7zI0S0ZF1a1DuLwvYoqhvDGQ2VLpAmUK6kIggWjuZv8PoLvFe4zf89B4KA=="
$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Name of the destination container
$destinationContainer = "merchantoneasset"
# Name of the container to exclude
$excludeContainer = "merchantoneasset"

# Ensure the destination container exists
if (!(Get-AzStorageContainer -Name $destinationContainer -Context $context -ErrorAction SilentlyContinue)) {
    New-AzStorageContainer -Name $destinationContainer -Context $context
}

# List all source containers, excluding the specified one
$containers = Get-AzStorageContainer -Context $context | Where-Object { $_.Name -ne $destinationContainer -and $_.Name -ne $excludeContainer }

# Copy blobs from each source container to the destination container
foreach ($container in $containers) {
    $blobs = Get-AzStorageBlob -Container $container.Name -Context $context
    foreach ($blob in $blobs) {
        $srcBlobUri = $blob.ICloudBlob.Uri.AbsoluteUri
        Start-AzStorageBlobCopy -AbsoluteUri $srcBlobUri -DestContainer $destinationContainer -DestBlob $blob.Name -Context $context
    }
}
