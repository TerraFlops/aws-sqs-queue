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