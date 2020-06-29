# main.tf
# provides general provisioning setup for SiteA

# Provider is AWS
# Credentials are loaded
# 1. from this stanza
# 2. from shell environment variables
# 3. from $HOME/.aws/credentials (default)

# Overwritting credential locations to a "shared" user
# this should help to prevent accidentally running Terraform
# with an AWS user not in the SiteA group.
provider "aws" {
    region                  = "us-west-2"
    shared_credentials_file = "/Users/ryan/.aws/credentials"
    profile                 = "me"
}
