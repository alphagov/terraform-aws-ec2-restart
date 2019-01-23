provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 1.18"

  profile = "${var.aws_profile}"
}

resource "aws_key_pair" "public" {
  key_name   = "example-key"
  public_key = "${file(var.ssh_public_key_file)}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.micro"
  count                       = 1
  associate_public_ip_address = true
  subnet_id                   = "${module.example_vpc.public_subnets[0]}"
  vpc_security_group_ids      = ["${module.example_sg.this_security_group_id}"]
  key_name                    = "${aws_key_pair.public.key_name}"

  user_data = "${data.template_file.cloudinit.rendered}"

  tags {
    ManagedBy = "terraform"
  }
}

data "template_file" "cloudinit" {
  template = "${file("./cloudinit/basic_setup.sh")}"

  vars {
    fqdn     = "my-server"
    hostname = "my-server"
  }
}
