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

data "aws_instance" "webservers_a" {
    filter {
        name   = "tag:name"
        values = ["webserver_a"]
    }
}

resource "aws_ebs_volume" "webs_vol_a" {
    availability_zone   = data.aws_instance.webservers_a.availability_zone
    size                = 10

    tags = {
        name        = "webserver_a"
        realm       = "sitea"
        trash_level = "high"
    }
}

resource "aws_volume_attachment" "webs_vol_att_a" {
    device_name = "/dev/sdh"
    volume_id   = aws_ebs_volume.webs_vol_a.id
    instance_id = data.aws_instance.webservers_a.id
}

resource "aws_ebs_volume" "webs_vol_b" {
    availability_zone   = data.aws_instance.webservers_a.availability_zone
    size                = 10

    tags = {
        name        = "webserver_a"
        realm       = "sitea"
        trash_level = "high"
    }
}

resource "aws_volume_attachment" "webs_vol_att_b" {
    device_name = "/dev/sdi"
    volume_id   = aws_ebs_volume.webs_vol_b.id
    instance_id = data.aws_instance.webservers_a.id
}
