# Set up Identity Federation for GitHub Actions

[![Badge: GitHub](https://img.shields.io/badge/GitHub-181717.svg?logo=github&logoColor=white)](#)

## Create Workload Identity Pool

Run in the following [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) commands...

Set project (replace `YOUR-GOOGLE-CLOUD-PROJECT-ID` with your project ID):

```bash
gcloud config set project YOUR-GOOGLE-CLOUD-PROJECT-ID
```

**Enable APIs:**

```bash
gcloud services enable iam.googleapis.com
gcloud services enable sts.googleapis.com
gcloud services enable iamcredentials.googleapis.com
```

**Create a Workload Identity Pool:**

```bash
gcloud iam workload-identity-pools create "github-com" \
--location="global" \
--display-name="github.com"
```

**Restrict access to GitHub organization:**

> **Warning**
> GitHub use a single issuer URL across all organizations and some of the claims embedded in OIDC tokens might not be unique to your organization.
> To help protect against spoofing threats, you must use an attribute condition that restricts access to tokens issued by your GitHub organization.

```bash
# Set username or the name of a GitHub organization
export GITHUB_ORGANIZATION="username" # i.e. "Cyclenerd" for https://github.com/Cyclenerd or "SAP" for https://github.com/SAP
```

**Create a Workload Identity Provider in that pool:**

```bash
gcloud iam workload-identity-pools providers create-oidc "github-com-oidc" \
--location="global" \
--workload-identity-pool="github-com" \
--display-name="github.com OIDC" \
--issuer-uri="https://token.actions.githubusercontent.com" \
--attribute-mapping="google.subject=assertion.sub,attribute.sub=assertion.sub,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
--attribute-condition="assertion.repository_owner == '${GITHUB_ORGANIZATION}'"
```

Attribute mapping:

| Attribute                         | Claim                             | Description |
|-----------------------------------|-----------------------------------|-------------|
| `google.subject`                  | `assertion.sub`                   | Subject
| `attribute.sub`                   | `assertion.sub`                   | Defines the subject claim that is to be validated by the cloud provider. This setting is essential for making sure that access tokens are only allocated in a predictable way.
| `attribute.repository`            | `assertion.repository`            | The repository from where the workflow is running. Contains the owner and repository name. Example `Cyclenerd/google-workload-identity-federation`.
| `attribute.repository_owner`      | `assertion.repository_owner`      | Contains the owner, which can be a username or the name of a GitHub organization. Example `Cyclenerd`.

Get the full ID of the Workload Identity Pool:

```bash
gcloud iam workload-identity-pools describe "github-com" \
--location="global" \
--format="value(name)"
```

Save this value as an environment variable:

```bash
export WORKLOAD_IDENTITY_POOL="..." # value from above
```

Save your GitHub repository as an environment variable:

```bash
export REPOSITORY="username/name" # i.e. "Cyclenerd/google-workload-identity-federation"
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
> This is the only way to avoid that all GitHub repositories can authenticate!

> **Note**
> You can also secure it even more by using the attributes `attribute.sub` instead.
> Instead of the Repsoitory name you can use the Subject (`sub`).
> Example for GitHub: `repo:octo-org/octo-repo:environment:prod`

## GitHub Actions

Extract the Workload Identity Provider resource name:

```bash
gcloud iam workload-identity-pools providers describe "github-com-oidc" \
--location="global" \
--workload-identity-pool="github-com" \
--format="value(name)"
```

Copy this name for your GitHub Actions configuration and add it to `workload_identity_provider`.

An example of a working GitHub Actions configuration can be found [here](https://github.com/Cyclenerd/google-workload-identity-federation/blob/master/.github/workflows/auth.yml) ([`.github/workflows/auth.yml`](https://github.com/Cyclenerd/google-workload-identity-federation/blob/master/.github/workflows/auth.yml)).

**More Help:**

* [Google GitHub Actions repo](https://github.com/google-github-actions/auth#setup)
* [Troubleshooting](https://github.com/google-github-actions/auth/blob/main/docs/TROUBLESHOOTING.md)
* [Google Blog](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions)
* [Google Documentation](https://cloud.google.com/iam/docs/configuring-workload-identity-federation#github-actions)


## GitHub OIDC token

```json
{
  "jti": "example-id",
  "sub": "repo:octo-org/octo-repo:environment:prod",
  "environment": "prod",
  "aud": "https://github.com/octo-org",
  "ref": "refs/heads/main",
  "sha": "example-sha",
  "repository": "octo-org/octo-repo",
  "repository_owner": "octo-org",
  "actor_id": "12",
  "repository_id": "74",
  "repository_owner_id": "65",
  "run_id": "example-run-id",
  "run_number": "10",
  "run_attempt": "2",
  "actor": "octocat",
  "workflow": "example-workflow",
  "head_ref": "",
  "base_ref": "",
  "event_name": "workflow_dispatch",
  "ref_type": "branch",
  "job_workflow_ref": "octo-org/octo-automation/.github/workflows/oidc.yml@refs/heads/main",
  "iss": "https://token.actions.githubusercontent.com",
  "nbf": 1632492967,
  "exp": 1632493867,
  "iat": 1632493567
}
```

Source: [GitHub OIDC token documentation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token)