variable "name" {
  description = "Name of the SQS queue"
  type = string
}

variable "policy_document" {
  description = "Optional policy document (JSON) to attach to the queue"
  type = string
  default = null
}

variable "message_retention_seconds" {
  description = "Optional override, default number of seconds to retain message"
  type = number
  default = null
}

variable "max_message_size" {
  description = "Optional override, maximum message size"
  type = number
  default = null
}

variable "content_based_deduplication" {
  description = "Boolean flag, if true queue will be deduplicated pased on message content"
  type = bool
  default = false
}

variable "kms_master_key_id" {
  description = "Optional KMS master key ID"
  type = string
  default = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Optional KMS data reuse period (seconds)"
  type = number
  default = null
}

variable "tags" {
  description = "Optional tags to attach to the queue"
  type = map(string)
  default = {}
}
