 
# Set your resource group and APIM service name
$resourceGroupName = "rg-bpay-apim-uat"
$serviceName = "api-bpay-uat"
 
# Create the APIM context
$apimContext = New-AzApiManagementContext -ResourceGroupName $resourceGroupName -ServiceName $serviceName
 
# Get all products in the APIM service
$products = Get-AzApiManagementProduct -Context $apimContext
 
# Create an array to hold the result
$result = @()
 
# Iterate through each product and get subscription keys
foreach ($product in $products) {
    # Get all subscriptions for the product
    $subscriptions = Get-AzApiManagementSubscription -Context $apimContext -ProductId $product.ProductId
 
    # Iterate through each subscription and get the keys
    foreach ($subscription in $subscriptions) {
        $keys = Get-AzApiManagementSubscriptionKey -Context $apimContext -SubscriptionId $subscription.SubscriptionId
        $result += [pscustomobject]@{
            ProductId   = $product.ProductId
            PrimaryKey  = $keys.PrimaryKey
            SecondaryKey = $keys.SecondaryKey
            SubscriptionID =$subscriptions.SubscriptionId
        }
    }
}
 
# Output the result in table format
$result |  Format-Table -AutoSize | Out-File -FilePath D:\outp.txt -Width 700