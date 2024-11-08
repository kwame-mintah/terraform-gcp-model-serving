variable "env_prefix" {
  description = <<-EOF
  The prefix added to resources in the environment.

EOF

  type = string
  validation {
    condition     = contains(["dev", "staging", "prod", "sandbox"], var.env_prefix)
    error_message = "The env_prefix value must be either: dev, staging, prod or sandbox."
  }
}

variable "gcp_default_labels" {
  description = <<-EOF
  Labels that will be applied to all resources with a top level labels field or a labels
  field nested inside a top level metadata field. 

EOF

  type    = map(string)
  default = {}
}

variable "gcp_region" {
  description = <<-EOF
  The default region to manage resources in.

EOF

  type = string
}

variable "gcp_project" {
  description = <<-EOF
  The default project to manage resources in.

EOF

  type = string
}

variable "gcp_zone" {
  description = <<-EOF
  The default zone to manage resources in. Generally, 
  this zone should be within the default region you specified.

EOF

  type = string
}

variable "project_name" {
  description = <<-EOF
  The name of the project.

EOF

  type = string
}