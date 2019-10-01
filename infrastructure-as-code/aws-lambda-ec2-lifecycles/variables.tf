variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}

# Set your Slack Webhook URL here.  For extra security you can use AWS KMS to 
# encrypt this data in the AWS console.
variable "slack_hook_url" {
  default = "https://hooks.slack.com/services/REPLACE/WITH/YOUR_WEBHOOK_URL"
  description = "Slack incoming webhook URL, get this from the slack management page."
}

variable "slack_channel" {
  default = "#aws-hc-se-demos"
  description = "Slack channel your bot will post messages to."
}

variable "mandatory_tags" {
  default = "TTL,owner"
  description = "Comma separated string mandatory tag values."
}

variable "ec2_sleep_days" {
  default = "14"
  description = "Days after launch after which untagged instances are stopped."
}

variable "ec2_reap_days" {
  default = "90"
  description = "Days after launch after which untagged instances are terminated."
}

variable "asg_reap_days" {
  default = "3"
  description = "Days after launch after which untagged ASGs are destroyed."
}

variable "is_active" {
  default = "False"
  description = "Determines whether scripts will actually stop and terminate instances or do a dry run instead."
}

variable "profile" {
  default = "default"
  description = "Determines AWS profile to use."
}


variable "default_tags" {
  type = "map"
  default = {
    "ApplicationID" = "vkvtest",
    "ApplicationName" = "vkvtest",
    "BU"= "vkvtest",
    "DeptID" = "vkvtest",
    "CoreID" = "vkvtest",
    "Env" = "dev",
    "ProjectID" = "vkvtest",
    "TerraformScriptVersion" = "0.12.9",
    "CreatedBy" = "vkvtest"
  }
}

variable "tags" {
}
