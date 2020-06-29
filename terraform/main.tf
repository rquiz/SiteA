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
    profile                 = "terraform"
}

# define basic network settings for isolated testing
############

resource "aws_vpc" "vpc_a" {
    cidr_block  = "10.0.0.0/16"
    tags        = {
        realm       = "sitea"
        trash_level = "low"
    }
}

resource "aws_internet_gateway" "gateway_a" {
    vpc_id  = aws_vpc.vpc_a.id
    tags    = {
        realm       = "sitea"
        trash_level = "low"
    }
}

resource "aws_route" "route_a" {
    route_table_id          = aws_vpc.vpc_a.main_route_table_id
    destination_cidr_block  = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.gateway_a.id
}

data "aws_availability_zones" "available" {}
 
resource "aws_subnet" "subnet_a" {
    count                   = length(data.aws_availability_zones.available.names)
    vpc_id                  = aws_vpc.vpc_a.id
    cidr_block              = "10.0.${count.index}.0/24"
    map_public_ip_on_launch = false
    availability_zone       = element(data.aws_availability_zones.available.names, count.index)
    tags                    = {
        realm       = "sitea"
        trash_level = "low"
    }
}

resource "aws_security_group" "sg_ingress_a" {
    name        = "http-https-allow"
    description = "Allow incoming HTTP and HTTPS and Connections"
    vpc_id      = aws_vpc.vpc_a.id

    ingress {
        description = "TLS from within VPC"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [aws_vpc.vpc_a.cidr_block]
    }
    
    ingress {
        description = "HTTP from world"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags        = {
        realm       = "sitea"
        trash_level = "medium"
    }
}

