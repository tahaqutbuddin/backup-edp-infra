# EDP-DA-Repo01-Infra-Base

## Description
This repository serves as the base infrastructure for the EDP-DA project.
Creates the following resources:
    1. Azure Container Registry
    2. Azure SQL Server and SQL Database
    3. Azure Key Vault for service_now Secrets

## Git Commands

### Clone Repository
To clone this repository locally, use:
```bash
git clone <repository_URL>
```

### Add Changes
To stage changes for commit, use:

```bash
git add <file_name>
```

### Commit Changes
To commit staged changes, use:

```bash
git commit -m "Your commit message here"
```

### Push Changes
To push committed changes to the remote repository, use:

```bash
git push <remote_name> <branch_name>
```

### Pull Changes
To fetch and merge changes from the remote repository, use:

```bash
git pull <remote_name> <branch_name>
```

## Terraform Commands

### Azure Login
To authenticate and login to Azure, use:

```bash
az login
```

### Initializing Terraform
Before using Terraform in this repository, run:

```bash
terraform init
```

### Validating Terraform Configuration
To validate the Terraform configuration, use:

```bash
terraform validate -var="environment=<environment_name>"
```

### Planning Terraform Changes
To plan and preview Terraform changes before applying, use:

```bash
terraform plan -var="environment=<environment_name>"
```

### Applying Changes
To apply changes defined in Terraform configuration, use:

```bash
terraform apply -var="environment=<environment_name>" -auto-approve
```