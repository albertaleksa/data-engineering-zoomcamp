### Concepts
* [Terraform_overview](../terraform_overview.md)

### Execution

```shell
# Refresh service-account's auth-token for this session
gcloud auth application-default login
```
 - Initialize state file (.tfstate).
At this moment terraform is downloading neaded plugins
`terraform init`

 - Check changes to new infra plan. Show which resources will be added
    or deleted. 
    ```
    terraform plan -var="project=<your-gcp-project-id>"
    ```
   We will use (from `main.tf` file)
   ```
   resource "google_storage_bucket" "data-lake-bucket"
   resource "google_bigquery_dataset" "dataset"
   ```
- Create new infra
    ```shell
    terraform apply -var="project=<your-gcp-project-id>"
    ```
- Delete infra after your work, to avoid costs on any running services
    ```shell
    terraform destroy
    ```