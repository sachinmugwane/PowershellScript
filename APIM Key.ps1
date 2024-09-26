$apimContext = New-AzApiManagementContext -ResourceGroupName "rg-bpay-apim-uat" -ServiceName "api-bpay-uat"
Get-AzApiManagementSubscriptionkey -Context $apimContext -SubscriptionId "1f1210f3sidssdsdsdb6f8-35ad9442f033"

