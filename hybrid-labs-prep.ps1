<#
Script to prepare the Azure Pass subscription for multiple participants.

For the number of participants specified, the script will:
1. Create a user account in the Entra ID directory
2. Create a resource group in the Azure subscription
3. Assign the user account as the owner of the resource group
4. Deploy the ARM template to the resource group with default parameters

Use PowerShell version 7+
#>

# Participant count - change this to the number of participants you want to create
$participantCount = 16

# Participant prefix - used for the user account and resource group names
$participantPrefix = "brisbane-"

# Default user password for the user accounts
$userPassword = "HardPass123!"

# Entra ID directory name - need this for the UPN
# $directoryName = "<FILL THIS IN>"
$directoryName = "demotime.live"

# Azure region to deploy resources
$location = "australiaeast"


# Check that az module is installed, install if not
if (-not (Get-Module -Name Az -ListAvailable)) {
    Write-Host "Az module not found, installing..."
    Install-Module -Name Az -AllowClobber -Force
    Write-Host "Az module installed"
}

# Sign in to Azure
az config set core.allow_broker=true
az login --scope https://graph.microsoft.com//.default

# Set the subscription, can remove this bit for the Azure Pass deployment
# az account set -n "<FILL THIS IN IF YOU GOT MULTIPLE SUBS>"

# Get the current subscription ID
$subscriptionId = az account show --query id --output tsv

# Azure resource providers registration - these can take a while so consider running them manually before the rest of the script
Write-Host "Registering Azure resource providers..."
az provider register --wait --namespace Microsoft.HybridCompute
az provider register --wait --namespace Microsoft.HybridNetwork
az provider register --wait --namespace Microsoft.HybridCloud
az provider register --wait --namespace Microsoft.Security
az provider register --wait --namespace Microsoft.Maintenance
az provider register --wait --namespace Microsoft.GuestConfiguration 
az provider register --wait --namespace Microsoft.AzureArcData
az provider register --wait --namespace Microsoft.OperationsManagement
az provider register --wait --namespace Microsoft.SecurityInsights
Write-Host "Azure resource providers registration complete."

# Enable Defender for Servers Plan 2 on the subscription
az security pricing create -n VirtualMachines --tier standard --subplan P2
# az security auto-provisioning-setting update -n "default" --auto-provision "On"

# Loop through the number of participants, creating user accounts and resource groups, and then the ARM deployment
for ($i = 1; $i -le $participantCount; $i++) {
    $userNumber = "{0:D2}" -f $i
    $participantName = $participantPrefix + $userNumber
    $userPrincipalName = "$participantName@$directoryName"

    # Check if the user account already exists
    $user = az ad user show --id $userPrincipalName
    if ($user) {
        Write-Host "User account already exists: $participantName"
    } else {
        Write-Host "Creating user account: $participantName"
        az ad user create --display-name $participantName --password $userPassword --user-principal-name $userPrincipalName --force-change-password-next-sign-in false
        Write-Host "User account created: $participantName"
    }

    # Create the resource group in the Azure subscription
    $resourceGroupName = $participantName + "-rg"
    az group create --name $resourceGroupName --location $location
    Write-Host "Resource group created: $resourceGroupName"

    # Get the resource group ID
    $resourceGroupId = az group show --name $resourceGroupName --query id --output tsv

    # Deploy the ARM template to the resource group with default parameters
    Write-Host "Deploying ARM template to resource group: $resourceGroupName. Will probably take around 20 mins or so..."
    az deployment group create --resource-group $resourceGroupName --template-file ./ARM/azuredeploy.json
    Write-Host "Deployment has completed for resource group: $resourceGroupName"

    $user = Get-EntraUser -UserId $userPrincipalName -ErrorAction SilentlyContinue
    if ($user) {
        # Assign the user account as the owner of the resource group
        az role assignment create --role "Owner" --assignee $userPrincipalName --scope $resourceGroupId
    }
    else {
        Write-Host "Unable to find user: $userPrincipalName"
    }
}

# Create a service principal to be shared with the participants, write the output to a file
az ad sp create-for-rbac --name "Arc server onboarding account" --role "Azure Connected Machine Onboarding" --scopes "/subscriptions/$subscriptionId" > arc-server-onboarding-spn.json
$spnAppId = (Get-Content arc-server-onboarding-spn.json | ConvertFrom-Json).appId

# Additional roles for module 7
az role assignment create --assignee $spnAppId --scope "/subscriptions/$subscriptionId" --role "Storage Account Contributor"
az role assignment create --assignee $spnAppId --scope "/subscriptions/$subscriptionId" --role "Resource Policy Contributor"
az role assignment create --assignee $spnAppId --scope "/subscriptions/$subscriptionId" --role "User Access Administrator"

Write-Host "All done."