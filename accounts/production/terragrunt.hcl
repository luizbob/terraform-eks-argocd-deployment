iam_role = "arn:aws:iam::************:role/admin-production"
remote_state = {
    backend = "s3"
    config = {
        encrypt = true
        bucket = "terraform-tfstate-production"
        key = "accounts/production/${path_relative_to_include()}"
        region = "sa-east-1"
        session_name = "terragrunt"
    }
}