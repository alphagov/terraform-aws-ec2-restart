# ###############################
# Permissions for Lambda function
# ###############################

resource "aws_iam_role" "ec2_restart_lambda_role" {
  name = "iam_for_ec2_restart_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "ec2_restart_policy_doc" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:StartInstances",
      "ec2:RebootInstances",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ec2_restart_policy" {
  name   = "ec2_restart_policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.ec2_restart_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "ec2_restart_policy_attach" {
  role       = "${aws_iam_role.ec2_restart_lambda_role.name}"
  policy_arn = "${aws_iam_policy.ec2_restart_policy.arn}"
}

# ###############
# Lambda function
# ###############

resource "aws_lambda_function" "ec2_restart_lambda" {
  filename      = "${path.module}/restart_ec2.zip"
  function_name = "restart_ec2"
  role          = "${aws_iam_role.ec2_restart_lambda_role.arn}"

  handler          = "restart_ec2.handler"
  source_code_hash = "${base64sha256(file("${path.module}/restart_ec2.zip"))}"
  runtime          = "python2.7"

  environment {
    variables = {
      IDS   = "${join("|",var.ec2_ids)}"
      DEBUG = "${var.debug}"
    }
  }
}

# #######
# Logging
# #######

# See https://www.terraform.io/docs/providers/aws/r/lambda_function.html

resource "aws_cloudwatch_log_group" "ec2_restart_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.ec2_restart_lambda.function_name}"
  retention_in_days = "${var.log_retention}"
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.ec2_restart_lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

# ##########
# Scheduling
# ##########

resource "aws_cloudwatch_event_rule" "minute" {
  name                = "every-minute"
  description         = "Runs once a minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "check_ec2_every_five_minutes" {
  rule      = "${aws_cloudwatch_event_rule.minute.name}"
  target_id = "check_ec2"
  arn       = "${aws_lambda_function.ec2_restart_lambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ec2_restart_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ec2_restart_lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.minute.arn}"
}
