
## Set up Identity Federation for GitHub Action

Run in Google Cloud Shell:
```bash
gcloud config set project YOUR-GOOGLE-CLOUD-PROJECT
```

Enable the IAM Credentials API:
```bash
gcloud services enable iamcredentials.googleapis.com \
--project="$GOOGLE_CLOUD_PROJECT"
```

Create a Workload Identity Pool:
```bash
gcloud iam workload-identity-pools create "github" \
--project="$GOOGLE_CLOUD_PROJECT" \
--location="global" \
--display-name="GitHub Action"
```

Create a Workload Identity Provider in that pool:
```bash
gcloud iam workload-identity-pools providers create-oidc "action" \
--project="$GOOGLE_CLOUD_PROJECT" \
--location="global" \
--workload-identity-pool="github" \
--display-name="GitHub Action OIDC" \
--attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
--issuer-uri="https://token.actions.githubusercontent.com"
```

Get the full ID of the Workload Identity Pool:
```bash
gcloud iam workload-identity-pools describe "github" \
--project="$GOOGLE_CLOUD_PROJECT" \
--location="global" \
--format="value(name)"
```

Save this value as an environment variable:
```bash
export WORKLOAD_IDENTITY_POOL_ID="..." # value from above
```

Save your GitHub repository as an environment variable
```bash
export REPO="username/name" # e.g. "Cyclenerd/google-workload-identity-federation"
```

Save the service account ID (email) as an environment variable:
```bash
export MY_SERVICE_ACCOUNT_EMAIL="my-service-account@PROJECT_ID.iam.gserviceaccount.com."
```

Allow authentications from the Workload Identity Provider originating from your repository to impersonate the Service Account:
```bash
gcloud iam service-accounts add-iam-policy-binding "$MY_SERVICE_ACCOUNT_EMAIL" \
--project="$GOOGLE_CLOUD_PROJECT" \
--role="roles/iam.workloadIdentityUser" \
--member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"
```

Extract the Workload Identity Provider resource name:
```bash
gcloud iam workload-identity-pools providers describe "action" \
--project="$GOOGLE_CLOUD_PROJECT" \
--location="global" \
--workload-identity-pool="github" \
--format="value(name)"
```

Copy this name for your GitHub Action.