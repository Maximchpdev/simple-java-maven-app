terraform {
  backend "s3" {
    bucket = "specialbucketofmaxim"
    region = "il-central-1"
    key    = "prod-eks-backend.tfstate"
  }
}
