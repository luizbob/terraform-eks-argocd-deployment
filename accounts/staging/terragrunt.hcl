iam_role = "arn:aws:iam::************:role/admin-staging"
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