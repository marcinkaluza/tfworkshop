# terraform-assets


## How to use shared Terraform assets

1. Download to local drive
2. Remove examples directory (optional)
4. Use [main.tf](./resources/main.tf) in the resources directory as starting point for building your infrastructure
5. Commit to your own gitlab repository
6. If you want to use CICD for deploying your projects infrastructure, deploy cicd_infra module and mirror gitlab repo to your infra code commit repo

## Creating CICD pipeline for infrastructure build

1. got to bootstrap, modify variables and run
3. Depending on services used modify policy.json file to grant appropriate permissions to terraform role
2. Deploy ci_cd pipeline module


## Available modules

#TODO: List of available modules with short description gores here

## Contributing
Please refer to [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

