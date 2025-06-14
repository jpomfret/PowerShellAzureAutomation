<# 
    Let's find resources that have been forgotten in Azure.
    This script will find unattached disks, network interfaces, and public IP addresses.
#>

# Ensures you do not inherit an AzContext in your runbook and connects to Azure using a Managed Service Identity
$null = Disable-AzContextAutosave -Scope Process

# Connect using a Managed Service Identity
try {
    Write-Output "Connecting to Azure using Managed Service Identity..."
    $AzureConnection = (Connect-AzAccount -Identity).context
    # set and store context
    $AzureContext = Set-AzContext -SubscriptionName $AzureConnection.Subscription -DefaultProfile $AzureConnection
}
catch {
    Write-Output "Issue connecting with managed identity. Aborting." 
    exit
}

# get disks that are not attached to any VM
    Write-Output "Retrieving unattached disks..."
    $disks = Get-AzDisk | Where-Object { $_.ManagedBy -eq $null }
if ($disks.Count -eq 0) {
    Write-Output "No unattached disks found."
} else {
    Write-Output "Unattached disks found:"
    $disks | ForEach-Object { Write-Output $_.Name }
}

# get network interfaces that are not attached to any VM
Write-Output "Retrieving unattached network interfaces..."
$networkInterfaces = Get-AzNetworkInterface | Where-Object { $_.VirtualMachine -eq $null -and $_.PrivateEndpointText -eq 'null' }
if ($networkInterfaces.Count -eq 0) {
    Write-Output "No unattached network interfaces found."
} else {
    Write-Output "Unattached network interfaces found:"
    $networkInterfaces | ForEach-Object { Write-Output $_.Name }
}

# get public IP addresses that are not attached to any network interface
Write-Output "Retrieving unattached public IP addresses..."
$publicIPs = Get-AzPublicIpAddress | Where-Object { $_.IpConfiguration -eq $null }

if ($publicIPs.Count -eq 0) {
    Write-Output "No unattached public IP addresses found."
} else {
    Write-Output "Unattached public IP addresses found:"
    $publicIPs | ForEach-Object { Write-Output $_.Name }
}
