# Create queue
resource "aws_sqs_queue" "queue" {
  name = "notifications"
  max_message_size = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  content_based_deduplication = var.content_based_deduplication
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  kms_master_key_id = var.kms_master_key_id
  tags = var.tags
}

# Optionally attach policy document to queue
resource "aws_sqs_queue_policy" "queue" {
  count = var.policy_document != null ? 1 : 0
  policy = var.policy_document
  queue_url = aws_sqs_queue.queue.id
}
