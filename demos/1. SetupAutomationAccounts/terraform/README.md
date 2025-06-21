# Terraform Azure Automation Project

This project provisions an Azure Resource Group and an Azure Automation Account using Terraform.

## Prerequisites

- Terraform installed on your machine.
- An Azure account with the necessary permissions to create resources.
- Azure CLI installed and configured to authenticate with your Azure account.

## Project Structure

```text
terraform-azure-automation
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
└── README.md
```

## Getting Started

<<<<<<< Updated upstream
1. **Clone the repository**:
=======
1. **Clone the repository** (if applicable):

>>>>>>> Stashed changes
   ```bash
   git clone <repository-url>
   cd terraform-azure-automation
   cd '.\demos\1. SetupAutomationAccounts\terraform\'
   ```

2. **Initialize Terraform**:
   Run the following command to initialize the Terraform configuration:

   ```bash
   terraform init
   ```

3. **Review the configuration**:
   You can see what resources will be created by running:

   ```bash
<<<<<<< Updated upstream
   terraform plan -out terraform.plan
=======
   terraform plan -out tf.plan
>>>>>>> Stashed changes
   ```

4. **Apply the configuration**:
   To create the resources defined in the configuration, run:

   ```bash
   terraform apply "terraform.plan"
   ```

## Outputs

After the resources are created, you can view the output values by running:

```bash
terraform output
```

## Cleanup

To remove the resources created by this project, run:

```bash
terraform destroy
```

## Notes

- Ensure that you have the correct permissions in your Azure account to create the specified resources.
- Modify the `terraform.tfvars` file to customize the resource names and locations as needed.
