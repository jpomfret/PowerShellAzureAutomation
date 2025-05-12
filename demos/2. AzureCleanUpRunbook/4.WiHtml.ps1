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

# If there are things to clean up - create a work item in Azure DevOps
if ($disks.Count -gt 0 -or $networkInterfaces.Count -gt 0 -or $publicIPs.Count -gt 0) {
    Write-Output "Creating Azure DevOps work item for cleanup..."
    # Create a new work item in Azure DevOps
    
    $token = (Get-AzAccessToken -AsSecureString:$false).token | ConvertFrom-SecureString -AsPlainText
    $headers = @{ Authorization = "Bearer $token"}
    
    $organization = "jpomfret7"
    $project = "ProjectPomfret"
    $type = "Task"
    $uri = ("https://dev.azure.com/{0}/{1}/_apis/wit/workitems/`${2}?api-version=7.1" -f $organization, $project , $type)

    # Create the description in html format
    # Create the HTML description with summary table and details
    # Create the HTML description with CSS-styled summary table and details
    $cssStyle = @"
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        th {
            background-color: #0078d4;
            color: white;
            text-align: left;
            padding: 8px;
        }
        td {
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #dcdcdc;
        }
        h3, h4 {
            color: #333333;
            margin-top: 20px;
        }
        ul {
            list-style-type: circle;
        }
        li {
            margin-bottom: 8px;
        }
        a {
            color: #0366d6;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
"@

    $htmlDesc = $cssStyle + @"
    <table>
    <tr>
        <th>Resource Type</th>
        <th>Count</th>
    </tr>
    <tr>
        <td>Unattached Disks</td>
        <td>$($disks.Count)</td>
    </tr>
    <tr>
        <td>Unattached Network Interfaces</td>
        <td>$($networkInterfaces.Count)</td>
    </tr>
    <tr>
        <td>Unattached Public IPs</td>
        <td>$($publicIPs.Count)</td>
    </tr>
    </table>
    <h3>Detailed Information</h3>
"@

    # Get the subscription ID for building portal links
    $subscriptionId = $AzureContext.Subscription.Id

    # Add disk details with links
    if ($disks.Count -gt 0) {
        $htmlDesc += "<h4>Unattached Disks</h4><ul>"
        foreach ($disk in $disks) {
            $portalLink = "https://portal.azure.com/#@/resource/subscriptions/$subscriptionId/resourceGroups/$($disk.ResourceGroupName)/providers/Microsoft.Compute/disks/$($disk.Name)"
            $htmlDesc += "<li><a href='$portalLink' target='_blank'>$($disk.Name)</a> | Resource Group: $($disk.ResourceGroupName) | Size: $($disk.DiskSizeGB) GB | Location: $($disk.Location)</li>"
        }
        $htmlDesc += "</ul>"
    }

    # Add network interface details with links
    if ($networkInterfaces.Count -gt 0) {
        $htmlDesc += "<h4>Unattached Network Interfaces</h4><ul>"
        foreach ($nic in $networkInterfaces) {
            $portalLink = "https://portal.azure.com/#@/resource/subscriptions/$subscriptionId/resourceGroups/$($nic.ResourceGroupName)/providers/Microsoft.Network/networkInterfaces/$($nic.Name)"
            $htmlDesc += "<li><a href='$portalLink' target='_blank'>$($nic.Name)</a> | Resource Group: $($nic.ResourceGroupName) | Location: $($nic.Location)</li>"
        }
        $htmlDesc += "</ul>"
    }

    # Add public IP details with links
    if ($publicIPs.Count -gt 0) {
        $htmlDesc += "<h4>Unattached Public IPs</h4><ul>"
        foreach ($ip in $publicIPs) {
            $portalLink = "https://portal.azure.com/#@/resource/subscriptions/$subscriptionId/resourceGroups/$($ip.ResourceGroupName)/providers/Microsoft.Network/publicIPAddresses/$($ip.Name)"
            $htmlDesc += "<li><a href='$portalLink' target='_blank'>$($ip.Name)</a> | Resource Group: $($ip.ResourceGroupName) | IP: $($ip.IpAddress) | Location: $($ip.Location)</li>"
        }
        $htmlDesc += "</ul>"
    }

    # Then update your workItem array to use this HTML description
    $workItem = @(
        @{
            "op"    = "add"
            "path"  = "/fields/System.Title"
            "value" = ("Azure Cleanup Task - {0}" -f (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))
        },
        @{
            "op"    = "add"
            "path"  = "/fields/System.Description"
            "value" = $htmlDesc
        }
    ) | ConvertTo-Json

    Invoke-RestMethod -Uri $uri -Method Post -Body $workItem -ContentType "application/json-patch+json" -Headers $headers
}
