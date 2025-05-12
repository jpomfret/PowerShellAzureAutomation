<# 
    We need to make sure there are terminating errors to fail the runbook
    You can set the preference for the whole runbook or for each command
#>
$ErrorActionPreference = 'Stop'

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
    Write-Output "There is no system-assigned user identity. Aborting." 
    exit
}

# get disks that are not attached to any VM
try {
    Write-Output "Retrieving unattached disks..."
    $disks = Get-AzDisk | Where-Object { $_.ManagedBy -eq $null }
    if ($disks.Count -eq 0) {
        Write-Output "No unattached disks found."
    } else {
        Write-Output "Unattached disks found:"
        $disks | ForEach-Object { Write-Output $_.Name }
    }
} catch {
    Throw "Error retrieving disks: $_"
}

# get network interfaces that are not attached to any VM
try {
    $networkInterfaces = Get-AzNetworkInterface | Where-Object { $_.VirtualMachine -eq $null -and $_.PrivateEndpointText -eq 'null' }
    if ($networkInterfaces.Count -eq 0) {
        Write-Output "No unattached network interfaces found."
    } else {
        Write-Output "Unattached network interfaces found:"
        $networkInterfaces | ForEach-Object { Write-Output $_.Name }
    }
} catch {
    Throw "Error retrieving network interfaces: $_"
}

# get public IP addresses that are not attached to any network interface
try {
    $publicIPs = Get-AzPublicIpAddress | Where-Object { $_.IpConfiguration -eq $null }

    if ($publicIPs.Count -eq 0) {
        Write-Output "No unattached public IP addresses found."
    } else {
        Write-Output "Unattached public IP addresses found:"
        $publicIPs | ForEach-Object { Write-Output $_.Name }
    }
} catch {
    Throw "Error retrieving public IP addresses: $_"
}
