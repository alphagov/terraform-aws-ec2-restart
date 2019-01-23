variable "aws_profile" {
  description = "AWS profile"
  type        = "string"
}

variable "aws_region" {
  description = "AWS region"
  type        = "string"
  default     = "eu-west-2"
}

variable "ssh_public_key_file" {
  description = "Location of public key used to access the server instances"
  type        = "string"
}

variable "allowed_ips" {
  description = "A list of IP addresses permitted to access (via SSH & HTTPS) the EC2 instances created that are running Jenkins"
  type        = "list"
}
