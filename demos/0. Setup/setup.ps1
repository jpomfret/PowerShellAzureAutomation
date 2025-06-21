# check account
$az = Get-AzContext

if($az.Account.id -ne 'jpomfret7@gmail.com') {
    Write-Error "You are not logged in as the correct user. Please log in with the right one " 
    try {
        Connect-AzAccount
    } catch {
        Write-Error "Failed to log in: $_"
        break
    }
} elseif ($az.Subscription.Name -ne 'Microsoft Azure Sponsorship') {
    Write-Error "You are not logged in to the correct subscription. Please switch to the Microsoft Azure Sponsorship subscription."
    try {
        Set-AzContext -SubscriptionName 'Microsoft Azure Sponsorship' -ErrorAction Stop
    } catch {
        Write-Error "Failed to switch subscription: $_"
        break
    }
} else {
    Write-Host ("You are logged in as {0} and using the {1} subscription." -f $az.Account.id, $az.Subscription.Name)
}

try {
    Remove-AzResourceGroup -Name rg-psconfeu-001 -Force -ErrorAction Stop
} catch {
    Write-Warning "Failed to remove resource group: $_"
}

az login

Invoke-Pester -Path $PSScriptRoot\tests\ -Output Detailed

Set-Location $PSScriptRoot\..\..

write-output ""

Write-Warning "Things to do Jess!
- Go put the subscription ID in the providers file
- Get VSCode Extension loaded and signed in
- pptx open?
- clean up ADO?
    - tickets and user\permissions
- login to ADO
- open ZoomIt

"