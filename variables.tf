variable "custom_tags" {
  description = "List of custom tags to apply to the resource"
  type        = "map"
  default     = {}
}

variable "resource_prefix" {
  description = "Prefix used for lamdba, etc. to avoid name clashes"
  type        = "string"
}

variable "ec2_ids" {
  description = "IDs of the EC2 instances which need to be monitored to ensure they're running. If they are detected to be not running then they're restarted"
  type        = "list"
}

variable "log_retention" {
  description = "Number of days logs are retained"
  type        = "string"
  default     = 1
}

variable "debug" {
  description = "Debug flag. If set to 1 then debug logging statements will be printed out by the Lambda function"
  type        = "string"
  default     = 0
}
