$resources = Get-AzResource
$report = @()

foreach ($resource in $resources) {
    $roleAssignments = Get-AzRoleAssignment -Scope $resource.ResourceId
    foreach ($roleAssignment in $roleAssignments) {
        $reportLine = @{
            Scope               = $resource.ResourceId
            Providers           = $resource.ResourceType
            DisplayName         = $roleAssignment.DisplayName
            RoleDefinitionName  = (Get-AzRoleDefinition -Id $roleAssignment.RoleDefinitionId).Name
            ObjectId            = $roleAssignment.ObjectId
            ObjectType          = $roleAssignment.ObjectType
        }
        $report += $reportLine
    }
}

$report | Export-Csv -Path D:\Report\Rewards_UAT.csv -NoTypeInformation

