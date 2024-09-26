
# Get all subscriptions
$subscriptions = Get-AzSubscription
 
# Initialize an empty array to hold the ticket details
$tickets = @()
 
foreach ($subscription in $subscriptions) {
    # Set the context to the current subscription
    Set-AzContext -SubscriptionId $subscription.Id
 
    # Get all open support tickets for the current subscription
    $openTickets = Get-AzSupportTicket | Where-Object { $_.Status -eq 'Open' }
 
    foreach ($ticket in $openTickets) {
        # Add the ticket details to the array
        $tickets += [PSCustomObject]@{
            Title              = $ticket.Title
            TicketID           = $ticket.SupportTicketId
            Subscription       = $subscription.Name
            CreatedDate        = $ticket.CreatedDate
            ServiceDisplayName = $ticket.ServiceDisplayName
            ModifiedDate       = $ticket.ModifiedDate
            Status             = $ticket.Status
        }
    }
}
 
# Output the ticket details
$tickets | Format-Table -AutoSize | Out-File -FilePath D:\ticket.txt -Width 700