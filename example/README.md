# EC2 restart example

## Overview

This is an example of using the [terraform-aws-ec2_restart](https://github.com/alphagov/terraform-aws-ec2_restart) module which is a terraform module to monitor and restart any EC2s that have shut down.

## How to build

1. Initialise Terraform

  Initialise Terraform using the following. You will only need to do this once.

  ```
  terraform init
  ```

2. Create `terraform.tfvars`

  Make a copy of the `terraform.tfvars.example` file, naming it `terraform.tfvars`. Edit this `terraform.tfvars` file, setting the `aws_az`, `aws_profile`, `aws_region`, `ssh_public_key_file` and `allowed_ips` variables as appropriate.

3. Create the infrastructure

  ```
  terraform plan -var-file=terraform.tfvars -out plan.out
  terraform apply plan.out
  ```

## How to test

Log in to the server whose IP address was printed out by the `terraform apply plan.out` command above then run:

```
# Only run this command on the test EC2 you have created!
sudo shutdown
```

The EC2 instance will shut down. It should start up again within a few minutes then you should be able to log in again.

Note:  
When the instance is restarted, it will have a _different_ public IP address.

## Viewing Lambda logs

You can view the logs created by the Lambda function that monitors the status of the EC2 instance. One way to view the logs is to use the [awslogs](https://github.com/jorgebastida/awslogs) utility with the following command:

```
awslogs get /aws/lambda/restart_ec2 --region=eu-west-1 -w
```
