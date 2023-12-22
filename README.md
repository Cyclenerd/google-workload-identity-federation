# Workload Identity Federation

[![Badge: Google Cloud](https://img.shields.io/badge/Google%20Cloud-%234285F4.svg?logo=google-cloud&logoColor=white)](#readme)
[![Badge: Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?logo=terraform&logoColor=white)](https://github.com/Cyclenerd/google-workload-identity-federation/tree/master/allow/examples#readme)
[![Badge: GitHub](https://img.shields.io/badge/GitHub-181717.svg?logo=github&logoColor=white)](./github.md)
[![Badge: GitLab](https://img.shields.io/badge/GitLab-FC6D26.svg?logo=gitlab&logoColor=white)](./gitlab.md)
[![Badge: Bitbucket](https://img.shields.io/badge/Bitbucket-0052CC.svg?logo=bitbucket&logoColor=white)](./bitbucket.md)

Service account keys are a security risk if compromised.
Avoid service account keys and instead use the [Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation).
You can learn more about the best way to authenticate service accounts on Google Cloud in this repo.

Unlike JSON service account keys, Workload Identity Federation generates short-lived OAuth 2.0 or JWT credentials.
By default, these credentials automatically expire one hour after they are created,
potentially reducing the time a malicious actor would be able to exploit a compromised credential.

Because Workload Identity Federation uses short-lived credentials, there are no secrets to rotate or manage beyond the initial configuration.

---

```mermaid
graph TD;
  user(GitHub, GitLab etc...) --> |1| token[GCP Security Token Services];
  token <--> |2| pool[Workload Identity Pool]
  user --> |3| sa[Service Account];
  sa --> gcp[Google Cloud Platform Service]
  user -.-> pool
  pool -.-> sa
```

---


## How-tos

Set up Identity Federation for:

* :octocat: **[GitHub Actions](./github.md)**
* 🦊 **[GitLab CI](./gitlab.md)**
* 🪣 **[Bitbucket pipelines](./bitbucket.md)**

You can check the settings in [Google Cloud Console](./console.md).

If you have understood the concept, you can also use my Terraform modules:

* Create Google Cloud Workload Identity for...
  * [GitHub](https://registry.terraform.io/modules/Cyclenerd/wif-github/google/latest)
  * [GitLab](https://registry.terraform.io/modules/Cyclenerd/wif-gitlab/google/latest)
  * [Bitbucket](https://registry.terraform.io/modules/Cyclenerd/wif-bitbucket/google/latest)
* [Allow Login via WIF for Service Accounts](https://registry.terraform.io/modules/Cyclenerd/wif-service-account/google/latest)

This Terraform IaC makes the setup much faster, easier, and less error prone.


## Disable Service Account Keys

You can disabled the key creation for service accounts via the organization policy constraint: `constraints/iam.disableServiceAccountKeyCreation`

This organization policy constraint is not mandatory, but with it you can be sure that no one will create new service account keys and Workload Identity Federation will be used.


## License

All files in this repository are under the [Apache License, Version 2.0](LICENSE) unless noted otherwise.

Portions of this repository are modifications based on work created and shared by [Google](https://developers.google.com/readme/policies)
and used according to terms described in the [Creative Commons 4.0 Attribution License](https://creativecommons.org/licenses/by/4.0/).

Please note:

* No warranty
* No official Google product
