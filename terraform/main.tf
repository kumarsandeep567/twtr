# The main entry-point for our Terraform configuration
# Set hashicorp/aws as a required provider

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}