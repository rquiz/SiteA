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

resource "aws_instance" "webserver_a" {
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = "t2.micro"
    associate_public_ip_address = true
    #vpc_security_group_ids      = [aws_security_group.sg_ingress_a.id.[0]]

    tags = {
        name        = "webserver_a"
        realm       = "sitea"
        trash_level = "high"
    }
}

