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
  value = length(var.opsgenie_responders) > 0 ? opsgenie_api_integration.opsgenie_integration.api_key : null
}
