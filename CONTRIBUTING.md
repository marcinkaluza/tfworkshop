# Contributing

Contributions to this projects are welcome, if you have an idea for a new module or would like to change something, please contact owners of this project first as the functionality you require may be already on the backlog or in development.

# Contribution guidelines


# How to contribute

1. Create fork of the repository.
2. Once completed, 


# Contribution guidelines

2. When creating new modules use _template directory as a starting point. It includes templates for README.md etc.
3. Ensure README.md contains the following:
* detailed description of the inputs
* detailed description of the outputs
* checkov warning being ignored (if any)
4. Once your module is complete, modify top level [README.md](./README.md) to include link to it and a brief description of the functionality it offers

# Terraform guidelines

1. Follow naming convention for resources (lowercase letters and underscores)
2. Run your code through checkov. Document exceptions if any
3. Run `terraform fmt -recursive` in your module's directory to format code
4. Do not use JSON strings when defining resources (use `jsonencode()` instead)
5. Avoid creating policies (`aws_iam_policy`) and use inline policies instead (`aws_iam_role_policy`)
6. Do not use hardcoded names for AWS resources to avoid name conflicts. Use prefixes or allow end user to specify name if needed
7. Provide mechanism for tagging resources created
8. Keep the list of input variables to a minimum. Provide meaningful defaults whenever possible
9. Do not use nested modules
10. Provide type and description for each input variable.
11. Provide descriptions for outputs
12. Use intuitive names for ooutputs (e.g. `arn` instead of `someresource_arn`)

