terraform {
  backend "s3" {
    bucket         = "taskmanager-tf-state"       # Create this S3 bucket in AWS first
    key            = "state/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "taskmanager-terraform-locks" # Create this DynamoDB table in AWS first
    encrypt        = true
  }
}