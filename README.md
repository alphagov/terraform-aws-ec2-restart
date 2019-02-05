# terraform-aws-restart_ec2

## Overview

This is a lightweight way of monitoring EC2 instances and restarting them if they are not running. It is a Terraform module and you just need to pass in the ids of the EC2 instances you want to monitor.

## Getting started

Just add the following to your [Terraform](https://www.terraform.io/) code, passing in the ids of the EC2s you'd like to monitor (in the `ec2_ids` parameter):

```
module "restart_ec2" {
  source = "git::git@github.com:alphagov/terraform-aws-ec2-restart.git"

  resource_prefix = "test"
  ec2_ids         = ["${aws_instance.example.id}"]
  debug           = 0
  custom_tags = {
    name = "test-ec2_restart"
  }
}
```

Please see the [example](example) for more information.

## Requirements

The Terraform code needs to be run by an AWS user/role with the following IAM policies attached:

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

## Inputs

| Name | Var Type | Required | Default | Description |
| :--- | :--- | :--: | :--- | :--- |
| `ec2_ids` | list | **yes** | none | IDs of the EC2 instances which need to be monitored to ensure they're running. If they are detected to be not running then they're restarted |
| `log_retention` | string | | 1 | Number of days logs are retained |
| `debug` | string | | 0 | Debug flag. If set to 1 then debug logging statements will be printed out by the Lambda function |
| `resource_prefix` | string | **yes** | none | Prefix used for lamdba, etc. to avoid name clashes |
| `custom_tags` | map | | none | List of custom tags to apply to the resource |

## Outputs

| Name | Description |
| :--- | :--- |
| `lamdba_arn` | ARN of the Cloudwatch lamdba instance created |
| `lamdba_log_group` | Name of the log group associated with the lamdba function created. This enables you to view the lambda logs (see https://docs.aws.amazon.com/lambda/latest/dg/monitoring-functions-logs.html). |
| `lamdba_log_group_arn` | ARN of the log group associated with the lamdba function created. This enables you to view the lambda logs (see https://docs.aws.amazon.com/lambda/latest/dg/monitoring-functions-logs.html). |
