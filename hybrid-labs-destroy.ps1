# Assumes you created the environment using the hybrid-labs-prep.ps1 script.

# Participant prefix - used for the user account and resource group names
$participantPrefix = "adelaide-"

# Entra ID directory name - need this for the UPN
# $directoryName = "<FILL THIS IN>"
$directoryName = "demotime.live"

# Check that az module is installed, install if not
if (-not (Get-Module -Name Az -ListAvailable)) {
    Write-Host "Az module not found, installing..."
    Install-Module -Name Az -AllowClobber -Force
    Write-Host "Az module installed"
}

# Sign in to Azure
az config set core.allow_broker=true
az login --scope https://graph.microsoft.com//.default

# Resource Graph extension is required for the query
az extension add -n resource-graph

# Set the subscription, can remove this bit for the Azure Pass deployment
# az account set -n "<FILL THIS IN IF YOU GOT MULTIPLE SUBS>"

# Use Azure Resource Graph to count the number of resource groups in the subscription
$existingResourceGroupCount = az graph query -q "resourcecontainers| where type == 'microsoft.resources/subscriptions/resourcegroups' and name startswith '$participantPrefix' | count" --query data[0].Count -o tsv

# convert to an integer
#$existingResourceGroupCount = [int]$existingResourceGroupCount

# If count is not an integer or is 0, exit
if (-not $existingResourceGroupCount -or $existingResourceGroupCount -eq 0) {
    Write-Host "No resource groups found with the prefix $participantPrefix"
    exit
} else {
    Write-Host "Found $existingResourceGroupCount existing resource groups with the prefix $participantPrefix"

    # Loop through the number of participants, creating user accounts and resource groups, and then the ARM deployment
    for ($i = 1; $i -le $existingResourceGroupCount; $i++) {
        $userNumber = "{0:D2}" -f $i
        $participantName = $participantPrefix + $userNumber
        $userPrincipalName = "$participantName@$directoryName"
        $resourceGroupName = $participantName + "-rg"

        # Delete the resource group
        Write-Host "Deleting resource group $resourceGroupName"
        az group delete --name $resourceGroupName --yes --no-wait

        # Delete the user account
        Write-Host "Deleting user account $userPrincipalName"
        az ad user delete --id $userPrincipalName 
    }
}

