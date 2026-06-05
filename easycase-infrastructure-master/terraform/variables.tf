variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  // Example Ubuntu 22.04 LTS in us-east-1. Update this to match your specific region and OS requirements.
  default     = "ami-0c7217cdde317cfec" 
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair to access the instance"
  type        = string
}
