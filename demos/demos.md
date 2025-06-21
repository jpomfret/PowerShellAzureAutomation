# notes

## Setting up resources

    1. create automation account in terraform
       1. navigate to `cd '.\demos\1. SetupAutomationAccounts\terraform\'`
       2. `terraform plan -out tf.plan`
       3. `terraform apply "tf.plan"`
    2. create runtime environment in az cli
    3. create runbook in Azure Portal (the only way I can find to specify the runtime environment)

## Runbook Code

    1. Through VSCode extension 
    2. add `1.CreateWI.ps1` code and run it
    3. update to `2.HTML.ps1` code and run it
