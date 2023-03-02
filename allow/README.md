<!-- BEGIN_TF_DOCS -->
# Allow Login via Workload Identity Provider

With this Terraform module you can allow service account to login via Workload Identity Providers.

Examples for using the module can be found in the [examples](examples/) folder.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.55.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The account id of the service account | `string` | n/a | yes |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | The resource name of the Workload Identity Pool | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | Repository patch (i.e. 'Cyclenerd/google-workload-identity-federation') | `string` | n/a | yes |
| <a name="input_subject"></a> [subject](#input\_subject) | Subject (i.e. 'repo:username/reponame:ref:refs/heads/main') | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->