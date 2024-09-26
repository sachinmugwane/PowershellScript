

# Set your resource group and APIM service name
$resourceGroupName = "rg-bpay-apim-uat"
$serviceName = "api-bpay-uat"
$productId = "test-gajendra" 

$apimContext = New-AzApiManagementContext -ResourceGroupName $resourceGroupName -ServiceName $serviceName

$product = Get-AzApiManagementProduct -Context $apimContext -ProductId $productId

# Regenerating Primary Key
 $PrimaryKey = (New-Guid) -replace ‘-’,’’
 $secondaryKey = (New-Guid) -replace ‘-’,’’
 
 #In Order to set a new value 
 $newvalue = Set-AzApiManagementSubscription -Context $apimContext -SubscriptionId "1f1210f3sidssdsdsdb6f8-35ad9442f033" -PrimaryKey $PrimaryKey -SecondaryKey $secondaryKey  -State "Active" 
 $updatedvalue = Get-AzApiManagementSubscription -Context $ApiManagementContext -ProductId $productId | select primarykey -ExpandProperty primarykey
 