# notes

## Setting up resources

    1. create automation account in terraform
       1. navigate to `cd '.\demos\1. SetupAutomationAccounts\terraform\'`
       2. `terraform plan -out tf.plan`
       3. `terraform apply "tf.plan"`
    2. create runtime environment in az cli
    3. create runbook in Azure Portal (the only way I can find to specify the runtime environment)

## Runbook Code

    1. Through VSCode extenstion - add 3.createWI.ps1 code and run it
       1. failed
       2. permissions
    2. Add PSHTML code and make it pretty
       1. 4.WiHTML
