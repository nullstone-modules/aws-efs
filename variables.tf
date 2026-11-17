variable "enable_backups" {
  type        = bool
  default     = true
  description = "bool ||| Enroll the file system in AWS Backup's automatic plan (aws/efs/automatic-backup-plan): daily backups kept 35 days."
}

variable "enforce_tls" {
  type        = bool
  default     = true
  description = "bool ||| Attach a file system policy that denies any access not using TLS. Clients must mount with TLS (e.g. efs-utils `-o tls`; the EFS CSI driver does this by default)."
}
