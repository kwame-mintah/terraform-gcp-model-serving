output "gcp_project_number" {
  description = <<-EOF
    The numeric identifier of the project.

EOF

  value = data.google_project.project.number
}

output "github_action_service_account_key" {
  description = <<-EOF
    The GitHub service account private key in JSON format, base64 encoded.
EOF

  value     = base64decode(google_service_account_key.github_actions_service_account_key[0].private_key)
  sensitive = true
}

output "prediction_service_account_key" {
  description = <<-EOF
    The prediction service private key in JSON format, base64 encoded.
EOF

  value     = base64decode(google_service_account_key.prediction_service_account_key.private_key)
  sensitive = true
}

output "predicition_service_docker_registry_id" {
  description = <<-EOF
    The prediction service docker registry ID.
EOF

  value = google_artifact_registry_repository.prediction_service_registry.id
}

output "predicition_service_docker_registry_name" {
  description = <<-EOF
    The prediction service docker registry name.
EOF

  value = google_artifact_registry_repository.prediction_service_registry.name
}
