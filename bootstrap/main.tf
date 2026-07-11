# ------------------------------------------------------------------------------
# 1. TERRAFORM STATE STORAGE (S3 Native Locking)
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "terraform_state" {
  # Globally unique name across all of AWS
  bucket        = "threat-composer-tf-state-umara-13245"
  force_destroy = true
}
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. ECR Repository
resource "aws_ecr_repository" "app_repo" {
  name                 = "threat-composer-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}