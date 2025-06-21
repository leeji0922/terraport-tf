variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "terraport"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "subnet_cidr" {
  description = "Subnet CIDR blocks"
  type        = map(list(string))
  default     = {
    public = ["10.10.0.0/24", "10.10.4.0/24"]
    private = ["10.10.8.0/24", "10.10.12.0/24"]
  }
}