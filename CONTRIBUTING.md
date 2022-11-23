# Contributing

Contributions to this projects are welcome, if you have an idea for a new module or would like to change something, please contact owners of this project first as the functionality you require may be already on the backlog or in development.

# How to contribute

1. Create fork of the repository.
2. use the forked repository to implement changes
3. Once the work in the forked repo has been completed, create merge request in the forked repo specifying terraform-assets repo's main branch as the target for the merge 
4. Once your code has been reviewed, the changes will be merged to the main branch


# Contribution guidelines

2. When creating new modules use _template directory as a starting point. It includes templates for README.md etc.
3. Ensure README.md contains the following:
* detailed description of the inputs
* detailed description of the outputs
* checkov warning being ignored (if any)
4. Once your module is complete, modify top level [README.md](./README.md) to include link to it and a brief description of the functionality it offers
5. Ensure your changes are backward compatible with existing resources
6. Ensure your code follows TF guidelines in the section below

# Terraform guidelines

1. Follow naming convention for terraform resources and modules (lowercase letters and underscores)
2. Run your code through checkov. Document exceptions if any
3. Run `terraform fmt -recursive` in your module's directory to format code
4. Run `terraform validate` in your module's directory to validate syntax and correctness
5. Do not use JSON strings when defining resources (use `jsonencode()` instead)
6. Avoid creating policies (`aws_iam_policy`) and use inline policies instead (`aws_iam_role_policy`)
7. Do not use hardcoded names for AWS resources to avoid name conflicts. Use prefixes or allow end user to specify name if needed
8. Provide mechanism for tagging resources created
9. Keep the list of input variables to a minimum. Provide meaningful defaults whenever possible
10. Do not use nested modules. Reuse existing modules whenever possible
11. Provide type and description for each input variable.
12. Provide descriptions for outputs
13. Use intuitive names for outputs (e.g. `arn` instead of `someresource_arn`)

