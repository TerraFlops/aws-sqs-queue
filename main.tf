locals {
  name_snake = join("", [for element in split("-", lower(var.name)) : title(element)])
}

variable "evaluation_periods" {
  type = number
  description = "Number of evaluation periods required before alarming"
  default = 5
}

variable "period" {
  type = number
  description = "Length of evaluatin period (seconds)"
  default = 60
}

variable "statistic" {
  type = string
  description = "Evaluation statistic (e.g. Maximum, Average)"
  default = "Average"
}

variable "threshold" {
  type = string
  description = "Number of visible queue messages before alarm triggers"
  default = 5000
}

# Create queue
resource "aws_sqs_queue" "queue" {
  name = var.name
  max_message_size = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  content_based_deduplication = var.content_based_deduplication
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  kms_master_key_id = var.kms_master_key_id
  tags = var.tags
  policy = var.policy_document
}

# Create CloudWatch alarm
resource "aws_cloudwatch_metric_alarm" "queue_message_visible_alarm" {
  alarm_name = "${local.name_snake}MessageVisible"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = var.evaluation_periods
  metric_name = "ApproximateNumberOfMessagesVisible"
  namespace = "AWS/SQS"
  period = var.period
  statistic = var.statistic
  threshold = var.threshold
  treat_missing_data = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.queue.name
  }
}