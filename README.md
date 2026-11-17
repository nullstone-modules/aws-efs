# aws-efs
Nullstone datastore creating a network file system using AWS EFS (Elastic File System).

## Backups

`enable_backups` (default `false`) enrolls the file system in the AWS-managed `aws/efs/automatic-backup-plan`: daily backups, kept 35 days.

## TLS

`enforce_tls` (default `false`) attaches a file system policy that denies any access not using TLS. The policy still allows `ClientMount`, `ClientWrite` and `ClientRootAccess` to any principal, so mounts are only refused when they are not encrypted in transit.

With `enforce_tls` on, clients must mount with TLS. The EFS CSI driver does this by default (`encryptInTransit=true`). A plain `mount -t nfs4` without efs-utils `-o tls` will be refused.

## Network access

The file system's security group starts empty. A connected app adds its own tcp/2049 rule.
