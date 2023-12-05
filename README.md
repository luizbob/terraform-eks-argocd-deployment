# Terraform EKS Argocd Deployment - Demo

The challenge requires to build a Infrastructure to deploy a new application, with high scalability and availability

## Requirements

- terragrunt >= 0.40.0
- terraform >= 1.3.3
- aws-cli >= 2.8.0
- argocd >= 2.8.0

## Infra Deployment

Configure your aws account using the aws cli following this doc: [AWS Cli Documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html#getting-started-quickstart-new)

Assuming that you have the following structure on AWS:

```text
Organization:
    - DescoShop - 123456789123
    | -> Staging - 123456789323
    | -> Production - 123466789123
```

To deploy the infrastructure you need to configure the **arn** from your environment accounts role inside `terragrunt.hcl` on the following paths:

`accounts/production/sa-east-1` for the **production** environment
`accounts/staging/sa-east-1` for the **staging** environment

eg:
```
iam_role = "paste-your-role-arn-here"
remote_state = {
    backend = "s3"
    config = {
        encrypt = true
        bucket = "terraform-tfstate-staging"
        key = "accounts/staging/${path_relative_to_include()}"
        region = "sa-east-1"
        session_name = "terragrunt"
    }
}
```

After that, you can deploy the infrasctructure using the following command, inside the paths:

`terragrunt apply`

Example to deploy the **cloudfront**:

```bash
cd accounts/staging/sa-east-1/cloudfront
terragrunt apply
```

On the **state** file, the following folder structure will be created:

```
└── accounts
    └──  staging
        └──  sa-east-1
            └── cloudfront
                └── terraform.tfstate
```

Because we have 2 accounts, we gonna have 2 buckets for preserving the state. We can use a single bucket if we want to separate only by the folders.

This is facilitated when using [Atlantis](https://www.runatlantis.io) to automate the pull requests for deploying the infrastructure.

Here is a example on how to use atlantis together with terragrunt [Atlantis With Terragrunt](https://medium.com/@unruly_mood/terragrunt-terraform-with-atlantis-to-automate-your-infrastructure-pull-requests-9832dd24e5bf)

### EKS

On the EKS, we used the production environment to install the argocd, only one instance of the ArgoCD server is enough to host both clusters.

To register a new cluster on Argo we can follow this doc: [argocd cluster](https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_cluster_add/)

Download the [ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/) and run the following commands *assuming that you have access to the accounts*

For the production account:

```bash
aws eks update-kubeconfig --region sa-east-1 --name production
argocd cluster add --aws-cluster-name production --aws-role-arn role_created_on_production_account
```

For the staging account:

```bash
aws eks update-kubeconfig --region sa-east-1 --name staging
argocd cluster add --aws-cluster-name staging --aws-role-arn role_created_on_staging_account
```

### RDS

From the RDS side, we created both instances and only allowed the VPC from the respective account to be able to access it.
Setting the security group represented as a module on the rds folder from each environment.

### CloudFront

The s3 bucket is created as private and we created the origin config on the cloudfront module.


### VPC

On the VPC side, we created a vpc with 3 subnets, one for public, private and database.
We also created the db subnet group to facilitate the integration with the rds module.
