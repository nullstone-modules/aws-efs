# 0.1.0 (Nov 17, 2026)
* Added `enable_backups` (default `false`) to enroll the file system in AWS Backup's `aws/efs/automatic-backup-plan`.
* Added `enforce_tls` (default `false`) to attach a file system policy that denies non-TLS access.
* Upgraded `ns` provider to `~> 0.13.0` and committed the provider lock file.
* Switched to `aws_tags` for proper resource attribution.
