module "example_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.30.0"

  name = "example_vpc"

  enable_dns_hostnames = true
  enable_dns_support   = true

  cidr = "10.0.0.0/16"

  azs            = ["${var.aws_region}a"]
  public_subnets = ["10.0.0.1/24"]

  # enable_nat_gateway = true
  # single_nat_gateway = true

  tags = {
    AvailabilityZone = "${var.aws_region}a"
    ManagedBy        = "terraform"
  }
}

module "example_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.22.0"

  name        = "example_sg_worker"
  description = "Security Group Allowing SSH"
  vpc_id      = "${module.example_vpc.vpc_id}"

  egress_rules = ["all-all"]

  # ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules       = ["ssh-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
