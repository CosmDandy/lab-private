resource "minio_s3_bucket" "backup" {
  bucket = "lab-private-backup"
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }
}
