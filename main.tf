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
  alarm_actions = [
    aws_sns_topic.message_count_alarm.arn
  ]
}

# Create SNS topic
resource "aws_sns_topic" "message_count_alarm" {
  name = "${local.name_snake}MessageCount"
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
  alarm_actions = [
    aws_sns_topic.message_age_alarm.arn
  ]
}

# Create SNS topic
resource "aws_sns_topic" "message_age_alarm" {
  name = "${local.name_snake}MessageAge"
}

# Retrieve Opsgenie users
data "opsgenie_user" "opsgenie_responders_users" {
  for_each = var.opsgenie_responders_users
  username = each.value
}

# Retrieve Opsgenie users
data "opsgenie_team" "opsgenie_responders_teams" {
  for_each = var.opsgenie_responders_teams
  name = each.value
}

# Create Opsgenie API integration
resource "opsgenie_api_integration" "opsgenie_integration" {
  count = var.opsgenie_integration_name != null && (length(var.opsgenie_responders_users) > 0 || length(var.opsgenie_responders_teams) > 0) ? 1 : 0
  name = "${var.opsgenie_integration_name}Sqs${local.name_snake}"
  type = "API"

  # Attach responders to the integration
  dynamic "responders" {
    for_each = var.opsgenie_responders_users
    content {
      type = "user"
      id = data.opsgenie_user.opsgenie_responders_users[responders.key].id
    }
  }
  dynamic "responders" {
    for_each = var.opsgenie_responders_teams
    content {
      type = "user"
      id = data.opsgenie_team.opsgenie_responders_teams[responders.key].id
    }
  }
}

resource "opsgenie_integration_action" "message_age" {
  integration_id = opsgenie_api_integration.opsgenie_integration.id
  create {
    name = "Create alert when age of oldest message exceeds specified threshold"
    tags = [
      "SQS",
      "ApproximateAgeOfOldestMessage"
    ]
    priority = "P3"
  }
}
