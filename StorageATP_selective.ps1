# Install az.security module
Install-Module Az.Security -Force

# Set subscription context
$sub = "fb03990d-8d00-4167-a2fd-58c793cb5c1d"
Set-AzContext -Subscription $sub

# Collect Storage Accounts in Subscription
$storeaccts = Get-AzStorageAccount

# Exports CSV list of storage accounts, customer can remove accounts as needed
$path = "C:\Temp"
If (!(Test-Path $path))
{
    New-Item -ItemType Directory -Path $path
}
$storeaccts | Export-Csv $path\storageaccounts.csv

# Prompt a break in script to allow the customer to modify the .CSV list
Read-Host -Prompt 'Please modify c:\temp\storageaccount.csv removing any storage accounts you do not want to have Storage ATP turned on, Once finished press enter to continue script'

# Import the modified storage account .csv list
$stores = Import-csv $path\storageaccounts.csv

# Disable ASC Storage protection on Subscription, switch to free
Write-Host  "Disabling Storage Account Protection on ASC"
Set-AzSecurityPricing -Name "StorageAccounts" -PricingTier "Free"

# Run through each storage id in imported modified list and enable ATP on Storage Account 
foreach($store in $stores){

    Enable-AzSecurityAdvancedThreatProtection -ResourceId $store.id
    Write-Host "Storage Account ATP Enabled on " $store.StorageAccountName

}