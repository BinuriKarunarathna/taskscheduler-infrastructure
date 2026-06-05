variable "aws_region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID"
  default     = "ami-0f58b397bc5c1f2e8"  # Update for your region
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of your AWS key pair"
  type        = string
}