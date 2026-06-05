terraform {
  backend "s3" {
    # REPLACE THIS with your unique bucket name
    bucket         = "easycase-infrastructure-tf-state"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    
    # REPLACE THIS with your DynamoDB table name for locking (Partition key must be LockID)
    dynamodb_table = "easycase-terraform-locks"
    encrypt        = true
  }
}
