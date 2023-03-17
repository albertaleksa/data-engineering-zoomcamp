## GCP Overview

[Video](https://www.youtube.com/watch?v=18jIzE41fJ4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=2)


### Project infrastructure modules in GCP:
* Google Cloud Storage (GCS): Data Lake
* BigQuery: Data Warehouse

(Concepts explained in Week 2 - Data Ingestion)

### Initial Setup

For this course, we'll use a free version (upto EUR 300 credits). 

1. Create an account with your Google email ID 
2. Create your first [project](https://console.cloud.google.com/) if you haven't already
    * New project -> Project name: **dtc-de**
    * and note down the **Project ID** (we'll use this later when deploying infra with TF)
3. Create [service account & authentication](https://cloud.google.com/docs/authentication/getting-started) for this project:
   * IAM & Admin -> Service accounts -> Create Service Account
   * Name: **dtc-de-user**
   * Grant `Viewer` role to begin with
   * Create New Key for this account (json)
   * Download service-account-keys (.json) for auth
4. Download [SDK](https://cloud.google.com/sdk/docs/quickstart) and install for local setup
5. Set environment variable to point to your downloaded GCP keys:
   * Create dir /.gc for gcloud service-account-keys in home folder and copy *.json key there (for convenient). 
   * Set var **GOOGLE_APPLICATION_CREDENTIALS**:
   ```
   $ export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   ```
   * Refresh token/session, and verify authentication (OAth authentication):
   ```
   $ gcloud auth application-default login
   ```
   * On web browser allow access
   
### Setup for Access
 
1. [IAM Roles](https://cloud.google.com/storage/docs/access-control/iam-roles) for Service account:
   * Go to the *IAM* section of *IAM & Admin* https://console.cloud.google.com/iam-admin/iam
   * Click the *Edit principal* icon for your service account.
   * Add these roles in addition to *Viewer* : **Storage Admin** + **Storage Object Admin** + **BigQuery Admin**
   
2. Enable these APIs for your project:
   * https://console.cloud.google.com/apis/library/iam.googleapis.com
   * https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com
   
3. Please ensure `GOOGLE_APPLICATION_CREDENTIALS` env-var is set.
   ```
   $ export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   ```
 
### Terraform Workshop to create GCP Infra
Continue [here](./terraform): `week_1_basics_n_setup/terraform_gcp/terraform`