output "lamdba_arn" {
  description = "ARN of the Cloudwatch lamdba instance created"
  value       = "${aws_lambda_function.ec2_restart_lambda.arn}"
}

output "lamdba_log_group" {
  description = "Name of the log group associated with the lamdba function created. This enables you to view the lambda logs (see https://docs.aws.amazon.com/lambda/latest/dg/monitoring-functions-logs.html)."
  value       = "${aws_cloudwatch_log_group.ec2_restart_lambda_log_group.name}"
}

output "lamdba_log_group_arn" {
  description = "Arn of the log group associated with the lamdba function created. This enables you to view the lambda logs (see https://docs.aws.amazon.com/lambda/latest/dg/monitoring-functions-logs.html)."
  value       = "${aws_cloudwatch_log_group.ec2_restart_lambda_log_group.arn}"
}
