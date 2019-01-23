# terraform-aws-restart_ec2

## Overview

This is a lightweight way of monitoring EC2 instances and restarting them if they are not running. It is a Terraform module and you just need to pass in the ids of the EC2 instances you want to monitor.

## Requirements

The Terraform code needs to be run by an AWS user/role with the following IAM policies:

  ```
  "iam:CreatePolicy",
  "iam:CreateRole",
  "iam:PassRole",
  "iam:CreatePolicyVersion",
  "iam:AttachRolePolicy",
  "iam:DetachRolePolicy",
  "iam:DeleteRole",
  "iam:DeletePolicy",
  "lambda:AddPermission",
  "lambda:RemovePermission"
  ```

## Getting started

Please see the [example](example).

## Changing the Lambda function

Once you've changed the Lambda function then zip it up using:

```
rm restart_ec2.zip && zip restart_ec2.zip restart_ec2.py
```

You will then need to reinstall the Lambda function in AWS from the directory from which you import this Terraform module (e.g. the `example` directory) using:

```
terraform taint -module ec2_restart_example aws_lambda_function.ec2_restart_lambda
```

Be very careful when you then run `terraform plan` and `terraform destroy` that you do not impact any other infrastructure.

## Checking your Lambda function has been loaded

```
aws lambda list-functions --region=[your AWS region] | grep restart_ec2
```
