$rg = 'rg-psconfeu-001'
$aa = 'aa-psconfeu-001'
$rt = 'PowerShell74'

az automation runtime-environment create -g $rg `
    --automation-account-name $aa `
    --name $rt `
    --location UKSouth `
    --language PowerShell `
    --version 7.4 `
    --default-packages "{Az:12.3.0}"

az automation runtime-environment package create -g $rg `
    --automation-account-name $aa `
    --runtime-environment-name $rt `
    --name PSHTML `
    --uri 'https://www.powershellgallery.com/api/v2/package/PSHTML/0.8.2' `
    --content-version 0.8.2

# can create runbook - but can't associate it with a runtime environment?
az automation runbook create -g $rg `
    --automation-account-name $aa `
    --name AzureCleanUpRunbook `
    --type PowerShell `
    --runtime-environment-name rt `
    --log-progress true `
    --description "Runbook to clean up unattached resources in Azure" `
    --content 1..\1.basic.ps1
