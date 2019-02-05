module "ec2_restart_example" {
  source = "git::git@github.com:alphagov/terraform-aws-ec2-restart.git"

  resource_prefix = "test"
  ec2_ids         = ["${aws_instance.example.*.id}"]
  debug           = 0

  custom_tags = {
    name = "test-ec2_restart"
  }
}
