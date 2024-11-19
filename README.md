# Terraform Google Cloud Platform (GCP) Model Serving

The main purpose of this repository is to create resources needed for model serving using Google Cloud Platform (GCP) cloud functions.
Notes can be found in my [notes-md](https://github.com/kwame-mintah/notes-md) repository. Model inference code can be found in [gcp-cloud-run-function-model-inference](https://github.com/kwame-mintah/gcp-cloud-run-function-model-inference).

## Development

### Dependencies

- [gcloud](https://cloud.google.com/sdk/docs/install)
- [terraform](https://www.terraform.io/)
- [terragrunt](https://terragrunt.gruntwork.io/)
- [terraform-docs](https://terraform-docs.io/) this is required for `terraform_docs` hooks
- [pre-commit](https://pre-commit.com/)

## Prerequisites

1. Have a [Google Cloud account](https://cloud.google.com/free) account and [associated credentials](https://cloud.google.com/docs/authentication/provide-credentials-adc#how-to).

## Usage

1. Navigate to the environment you would like to deploy,
2. Initialize the configuration with:

   ```bash
   terragrunt init
   ```

3. Plan your changes with:

   ```bash
   terragrunt plan
   ```

4. If you're happy with the changes

   ```bash
   terragrunt apply
   ```

> [!NOTE]
> Please note that terragrunt will create a bucket for storing the remote state. Ensure the account deploying the
> resources has the appropriate permissions to create or connect to these resources.

## Pre-Commit hooks

Git hook scripts are very helpful for identifying simple issues before pushing any changes. Hooks will run on every commit automatically pointing out issues in the code e.g. trailing whitespace.

To help with the maintenance of these hooks, [pre-commit](https://pre-commit.com/) is used, along with [pre-commit-hooks](https://pre-commit.com/#install).

Please following [these instructions](https://pre-commit.com/#install) to install `pre-commit` locally and ensure that you have run `pre-commit install` to install the hooks for this project.

Additionally, once installed, the hooks can be updated to the latest available version with `pre-commit autoupdate`.

## Documentation Generation

Code formatting and documentation for `variables` and `outputs` is generated using [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform/releases) hooks that in turn uses [terraform-docs](https://github.com/terraform-docs/terraform-docs) that will insert/update documentation. The following markers have been added to the `README.md`:

```
<!-- {BEGINNING|END} OF PRE-COMMIT-TERRAFORM DOCS HOOK --->
```

## Retrieving service account secrets for GitHub Action(s) and Model Inference Service

Two service accounts are created and need to be referenced within the [gcp-cloud-run-function-model-inference](https://github.com/kwame-mintah/gcp-cloud-run-function-model-inference?tab=readme-ov-file#github-action-cicd) repository.
In order to retrieve these secrets to be used elsewhere, the following command can be used:

```shell
terragrunt output -raw prediction_service_account_key > prediction_service_account.json \
terragrunt output -raw github_action_service_account_key > github_action_service_account.json
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7, <= 1.9.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_artifact_registry_repository.prediction_service_registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository) | resource |
| [google_project_iam_binding.github_actions_registry_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prediction_service_account_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_service_account.github_actions_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.prediction_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.github_actions_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_service_account_key.prediction_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_storage_bucket.mlflow_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | The prefix added to resources in the environment. | `string` | n/a | yes |
| <a name="input_gcp_default_labels"></a> [gcp\_default\_labels](#input\_gcp\_default\_labels) | Labels that will be applied to all resources with a top level labels field or a labels<br>field nested inside a top level metadata field. | `map(string)` | `{}` | no |
| <a name="input_gcp_project"></a> [gcp\_project](#input\_gcp\_project) | The default project to manage resources in. | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | The default region to manage resources in. | `string` | n/a | yes |
| <a name="input_gcp_zone"></a> [gcp\_zone](#input\_gcp\_zone) | The default zone to manage resources in. Generally, <br>this zone should be within the default region you specified. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gcp_project_number"></a> [gcp\_project\_number](#output\_gcp\_project\_number) | The numeric identifier of the project. |
| <a name="output_github_action_service_account_key"></a> [github\_action\_service\_account\_key](#output\_github\_action\_service\_account\_key) | The GitHub service account private key in JSON format, base64 encoded. |
| <a name="output_predicition_service_docker_registry_id"></a> [predicition\_service\_docker\_registry\_id](#output\_predicition\_service\_docker\_registry\_id) | The prediction service docker registry ID. |
| <a name="output_predicition_service_docker_registry_name"></a> [predicition\_service\_docker\_registry\_name](#output\_predicition\_service\_docker\_registry\_name) | The prediction service docker registry name. |
| <a name="output_prediction_service_account_key"></a> [prediction\_service\_account\_key](#output\_prediction\_service\_account\_key) | The prediction service private key in JSON format, base64 encoded. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK --->
