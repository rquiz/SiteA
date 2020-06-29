# EC2.tf
# define  compute instances

# Ensure loading Ubuntu AMI from canonical
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_subnet_ids" "subnets_a" {
  vpc_id = aws_vpc.vpc_a.id
}

resource "aws_instance" "webserver_a" {
    count                       = 1
    ami                         = data.aws_ami.ubuntu.id
    associate_public_ip_address = true
    instance_type               = "t2.micro"
    key_name                    = "me" # personal key
    subnet_id                   = element(tolist(data.aws_subnet_ids.subnets_a.ids), count.index)
    vpc_security_group_ids      = [aws_security_group.sg_ingress_a.id]

    tags = {
        name        = "webserver_a"
        realm       = "sitea"
        trash_level = "high"
    }
}

