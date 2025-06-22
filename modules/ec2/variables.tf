variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "terraport"
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = map
  default     = {
    bastion = "t3.micro"
  }
}

variable "home_ip_cidr" {
  description = "home ip"
  type        = string
  default     = "1.230.76.70/32"
}


#다른 모듈에서 읽어 오는 값
variable "bastion_subnet_id" {
  description = "subnet id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}