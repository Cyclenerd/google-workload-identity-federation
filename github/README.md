<!-- BEGIN_TF_DOCS -->
# Workload Identity Pool and Provider for GitHub

This Terraform module creates a Workload Identity Pool and Provider for GitHub.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.55.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_issuer_uri"></a> [issuer\_uri](#input\_issuer\_uri) | Workload Identity Pool Provider issuer URI | `string` | `"https://token.actions.githubusercontent.com"` | no |
| <a name="input_pool_description"></a> [pool\_description](#input\_pool\_description) | Workload Identity Pool description | `string` | `"Workload Identity Pool for GitHub (Terraform managed)"` | no |
| <a name="input_pool_disabled"></a> [pool\_disabled](#input\_pool\_disabled) | Workload Identity Pool disabled | `bool` | `false` | no |
| <a name="input_pool_display_name"></a> [pool\_display\_name](#input\_pool\_display\_name) | Workload Identity Pool display name | `string` | `"github.com"` | no |
| <a name="input_pool_id"></a> [pool\_id](#input\_pool\_id) | Workload Identity Pool ID | `string` | `"github-com"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project | `string` | n/a | yes |
| <a name="input_provider_description"></a> [provider\_description](#input\_provider\_description) | Workload Identity Pool Provider description | `string` | `"Workload Identity Pool Provider for GitHub (Terraform managed)"` | no |
| <a name="input_provider_disabled"></a> [provider\_disabled](#input\_provider\_disabled) | Workload Identity Pool Provider disabled | `bool` | `false` | no |
| <a name="input_provider_display_name"></a> [provider\_display\_name](#input\_provider\_display\_name) | Workload Identity Pool Provider display name | `string` | `"github.com OIDC"` | no |
| <a name="input_provider_id"></a> [provider\_id](#input\_provider\_id) | Workload Identity Pool Provider ID | `string` | `"github-com-oidc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pool_id"></a> [pool\_id](#output\_pool\_id) | Identifier for the pool |
| <a name="output_pool_name"></a> [pool\_name](#output\_pool\_name) | Name for the pool |
| <a name="output_pool_state"></a> [pool\_state](#output\_pool\_state) | State of the pool |
| <a name="output_provider_id"></a> [provider\_id](#output\_provider\_id) | Identifier for the provider |
| <a name="output_provider_name"></a> [provider\_name](#output\_provider\_name) | The resource name of the provider |
| <a name="output_provider_state"></a> [provider\_state](#output\_provider\_state) | State of the provider |
<!-- END_TF_DOCS -->