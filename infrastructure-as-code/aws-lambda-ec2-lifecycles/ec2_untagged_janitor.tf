# This lambda is intended to deal with untagged instances by either stopping
# and then terminating them according to your lifecycle policy.
resource "aws_lambda_function" "EC2Janitor" {
  filename         = "./files/EC2Janitor.zip"
  function_name    = "EC2Janitor"
  role             = "${aws_iam_role.lambda_stop_and_terminate_instances.arn}"
  handler          = "EC2Janitor.lambda_handler"
  source_code_hash = "${base64sha256(filebase64sha256("./files/EC2Janitor.zip"))}"
  runtime          = "python3.6"
  timeout          = "120"
  description      = "Stops or terminates untagged instances after a pre-set number of days."
  environment {
    variables = {
      slackChannel = "${var.slack_channel}"
      slackHookUrl = "${var.slack_hook_url}"
      sleepDays = "${var.ec2_sleep_days}"
      reapDays = "${var.ec2_reap_days}"
      isActive = "${var.is_active}"
    }
  }
}

# Here we create a cloudwatch event rule, essentially a cron job that
# will call our lambda function every day.  Adjust to your schedule.
resource "aws_cloudwatch_event_rule" "clean_untagged_instances" {
  name = "clean_untagged_instances"
  description = "Check untagged instances and stop/terminate old ones"
  schedule_expression = "cron(0 8 * * ? *)"
}

resource "aws_cloudwatch_event_target" "untagged_instance_cleanup" {
  rule      = "${aws_cloudwatch_event_rule.clean_untagged_instances.name}"
  target_id = "${aws_lambda_function.EC2Janitor.function_name}"
  arn = "${aws_lambda_function.EC2Janitor.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_clean_untagged_instances" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.EC2Janitor.function_name}"
  principal      = "events.amazonaws.com"
  source_arn     = "${aws_cloudwatch_event_rule.clean_untagged_instances.arn}"
  depends_on = [
    "aws_lambda_function.EC2Janitor"
  ]
}