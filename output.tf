output "arn" {
  value = aws_sqs_queue.queue.arn
}

output "url" {
  value = aws_sqs_queue.queue.id
}

output "name" {
  value = aws_sqs_queue.queue.name
}

output "sns_topic_message_age_alarm" {
  value = aws_sns_topic.message_age_alarm.name
}

output "sns_topic_message_count_alarm" {
  value = aws_sns_topic.message_count_alarm.name
}

output "opsgenie_api_key" {
  description = "If a list of Opsgenie responders was specified, this will be the API key of the Opsgenie integration"
  value = var.opsgenie_integration_name != null && (length(var.opsgenie_responders_users) > 0 || length(var.opsgenie_responders_teams) > 0) ? opsgenie_api_integration.opsgenie_integration[0].api_key : null
}
