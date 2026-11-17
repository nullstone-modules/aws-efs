resource "aws_efs_file_system" "this" {
  encrypted      = true
  creation_token = local.resource_name
  tags           = merge(local.tags, { Name = local.resource_name })
}

resource "aws_efs_mount_target" "file" {
  count = length(local.private_subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = local.private_subnet_ids[count.index]
  security_groups = [aws_security_group.this.id]
}

resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = var.enable_backups ? "ENABLED" : "DISABLED"
  }
}

// Deny non-TLS access. The explicit Allow is required: once any policy exists,
// EFS stops applying its default allow-all policy.
resource "aws_efs_file_system_policy" "this" {
  count = var.enforce_tls ? 1 : 0

  file_system_id = aws_efs_file_system.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowClientAccess"
        Effect    = "Allow"
        Principal = { AWS = "*" }
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientRootAccess",
        ]
        Resource = aws_efs_file_system.this.arn
      },
      {
        Sid       = "DenyNonTLS"
        Effect    = "Deny"
        Principal = { AWS = "*" }
        Action    = "elasticfilesystem:*"
        Resource  = aws_efs_file_system.this.arn
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
    ]
  })
}
