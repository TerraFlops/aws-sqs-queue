locals {
  name_snake = join("", [for element in split("-", lower(var.name)) : title(element)])
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
resource "aws_cloudwatch_metric_alarm" "message_count_alarm" {
  alarm_name = "${local.name_snake}MessageCount"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name = "ApproximateNumberOfMessagesVisible"
  namespace = "AWS/SQS"
  treat_missing_data = "notBreaching"
  evaluation_periods = var.message_count_evaluation_periods
  period = var.message_count_period
  statistic = var.message_count_statistic
  threshold = var.message_count_threshold

  dimensions = {
    QueueName = aws_sqs_queue.queue.name
  }
}

# Create CloudWatch alarm for the age of messages in the queue
resource "aws_cloudwatch_metric_alarm" "message_age_alarm" {
  alarm_name = "${local.name_snake}MessageAge"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name = "ApproximateAgeOfOldestMessage"
  namespace = "AWS/SQS"
  treat_missing_data = "notBreaching"
  evaluation_periods = var.message_age_evaluation_periods
  period = var.message_age_period
  statistic = var.message_age_statistic
  threshold = var.message_age_threshold

  dimensions = {
    QueueName = aws_sqs_queue.queue.name
  }
}