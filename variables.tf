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


variable "message_count_evaluation_periods" {
  type = number
  description = "Number of evaluation periods required for visible message count alarm before alarming"
  default = 5
}

variable "message_count_period" {
  type = number
  description = "Length of evaluation period for visible message count alarm (seconds)"
  default = 60
}

variable "message_count_statistic" {
  type = string
  description = "Evaluation statistic for visible message count alarm (e.g. Maximum, Average)"
  default = "Average"
}

variable "message_count_threshold" {
  type = number
  description = "Number of visible queue messages for visible message count alarm before alarm triggers"
  default = 1000
}
variable "message_age_evaluation_periods" {
  type = number
  description = "Number of evaluation periods required for oldest message age alarm before alarming"
  default = 5
}

variable "message_age_period" {
  type = number
  description = "Length of evaluation period for oldest message age alarm (seconds)"
  default = 60
}

variable "message_age_statistic" {
  type = string
  description = "Evaluation statistic for oldest message age alarm (e.g. Maximum, Average)"
  default = "Average"
}

variable "message_age_threshold" {
  type = number
  description = "Number of visible queue messages for oldest message age alarm before alarm triggers"
  default = 300
}

variable "opsgenie_integration_name" {
  type = string
  description = "Opsgenie integration name"
  default = null
}

variable "opsgenie_responders" {
  type = set(string)
  description = "Set of Opsgenie usernames to be configure as responders"
  default = []
}
