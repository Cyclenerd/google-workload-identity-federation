# Set up Identity Federation for GitLab CI

Run in the following [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) commands...

Set project (replace `YOUR-GOOGLE-CLOUD-PROJECT-ID` with your project ID):
```bash
gcloud config set project YOUR-GOOGLE-CLOUD-PROJECT
```

Enable APIs:
```bash
gcloud services enable iam.googleapis.com
gcloud services enable sts.googleapis.com
gcloud services enable iamcredentials.googleapis.com
```

Create a Workload Identity Pool:
```bash
gcloud iam workload-identity-pools create "gitlab-com" \
--location="global" \
--display-name="gitlab.com"
```

Create a Workload Identity Provider in that pool:
```bash
gcloud iam workload-identity-pools providers create-oidc "gitlab-com-oidc" \
--location="global" \
--workload-identity-pool="gitlab-com" \
--display-name="gitlab.com OIDC" \
--attribute-mapping="google.subject=assertion.sub,attribute.sub=assertion.sub,attribute.repository=assertion.project_path" \
--issuer-uri="https://gitlab.com" \
--allowed-audiences="https://gitlab.com"
```

> **Note**
> Issuer URL `issuer-uri` and allowed audiences `allowed-audiences` must be `https://gitlab.com`.

Attribute mapping:

| Attribute                         | Claim                             | Description |
|-----------------------------------|-----------------------------------|-------------|
| `google.subject`                  | `assertion.sub`                   | Subject
| `attribute.sub`                   | `assertion.sub`                   | Defines the subject claim (`project_path:{group}/{project}:ref_type:{type}:ref:{branch_name}`) that is to be validated by the cloud provider. This setting is essential for making sure that access tokens are only allocated in a predictable way.
| `attribute.repository`            | `assertion.project_path`          | The repository (project path) from where the workflow is running (not `assertion.repository`)

Get the full ID of the Workload Identity Pool:
```bash
gcloud iam workload-identity-pools describe "gitlab-com" \
--location="global" \
--format="value(name)"
```

Save this value as an environment variable:
```bash
export WORKLOAD_IDENTITY_POOL="..." # value from above
```

Save your GitLab repository as an environment variable
```bash
export REPOSITORY="username/name" # i.e. "Cyclenerd/google-workload-identity-federation-for-gitlab"
```

Save the service account ID (email) as an environment variable:
```bash
export SERVICE_ACCOUNT_EMAIL="MY-SERVICE-ACCOUNT-NAME@MY-PROJECT_ID.iam.gserviceaccount.com."
```

Allow authentications from the Workload Identity Provider originating from your repository to impersonate the Service Account:
```bash
gcloud iam service-accounts add-iam-policy-binding "$SERVICE_ACCOUNT_EMAIL" \
--role="roles/iam.workloadIdentityUser" \
--member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL}/attribute.repository/${REPOSITORY}"
```

> **Warning**
> Setting the correct `principalSet` with `attribute.repository` is very important.
> This is the only way to avoid that all GitLab repositories can authenticate!

> **Note**
> You can also secure it even more by using the attributes `attribute.sub` instead.
> Instead of the Repsoitory name you can use the Subject (`sub`).
> Example for GitLab: `project_path:mygroup/myproject:ref_type:branch:ref:main`

Extract the Workload Identity Provider resource name:
```bash
gcloud iam workload-identity-pools providers describe "gitlab-com-oidc" \
--location="global" \
--workload-identity-pool="gitlab-com" \
--format="value(name)"
```

Copy this name for your GitLab CI configuration (`gitlab-ci.yml`).

**GitLab CI:**

An example of a working GitLab CI configuration can be found [here](.gitlab-ci.yml) ([`.gitlab-ci.yml`](.gitlab-ci.yml)) or on [GitLab](https://gitlab.com/Cyclenerd/google-workload-identity-federation-for-gitlab/-/blob/master/.gitlab-ci.yml).

**More Help:**

* [GitLab Documentation](https://docs.gitlab.com/ee/ci/cloud_services/google_cloud/)
* [GitLab OpenID Connect in GCP repo](https://gitlab.com/guided-explorations/gcp/configure-openid-connect-in-gcp)

## GitLab OIDC Token

```json
{
  "jti": "c82eeb0c-5c6f-4a33-abf5-4c474b92b558",
  "iss": "https://gitlab.example.com",
  "aud": "https://gitlab.example.com",
  "iat": 1585710286,
  "nbf": 1585798372,
  "exp": 1585713886,
  "sub": "project_path:mygroup/myproject:ref_type:branch:ref:main",
  "namespace_id": "1",
  "namespace_path": "mygroup",
  "project_id": "22",
  "project_path": "mygroup/myproject",
  "user_id": "42",
  "user_login": "myuser",
  "user_email": "myuser@example.com",
  "pipeline_id": "1212",
  "pipeline_source": "web",
  "job_id": "1212",
  "ref": "auto-deploy-2020-04-01",
  "ref_type": "branch",
  "ref_protected": "true",
  "environment": "production",
  "environment_protected": "true"
}
```
Source: [GitLab OIDC token documentation](https://docs.gitlab.com/ee/ci/cloud_services/index.html#how-it-works)