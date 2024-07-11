# We will use AWS as our cloud provider and set the 
# AWS region as per the variable in variables.tf or
# terraform.tfvars

provider "aws" {
    access_key  = var.user_credentials.access_key
    secret_key  = var.user_credentials.secret_key
    region      = var.cluster_config.region
}