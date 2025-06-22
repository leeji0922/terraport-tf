output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

# Lambda Functions Outputs
output "lambda_ec2_function_name" {
  description = "EC2 Lambda function name"
  value       = aws_lambda_function.ec2_function.function_name
}

output "lambda_ec2_function_arn" {
  description = "EC2 Lambda function ARN"
  value       = aws_lambda_function.ec2_function.arn
}

output "lambda_save_files_function_name" {
  description = "Save Files Lambda function name"
  value       = aws_lambda_function.save_files_function.function_name
}

output "lambda_save_files_function_arn" {
  description = "Save Files Lambda function ARN"
  value       = aws_lambda_function.save_files_function.arn
}

output "lambda_subnet_list_function_name" {
  description = "Subnet List Lambda function name"
  value       = aws_lambda_function.subnet_list_function.function_name
}

output "lambda_subnet_list_function_arn" {
  description = "Subnet List Lambda function ARN"
  value       = aws_lambda_function.subnet_list_function.arn
}

output "api_gateway_url" {
  description = "API Gateway URL"
  value       = "${aws_api_gateway_stage.main.invoke_url}/{proxy+}"
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = aws_api_gateway_rest_api.main.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

# KMS Key outputs
output "kms_key_id" {
  description = "KMS Key ID"
  value       = aws_kms_key.terraport_key.key_id
}

output "kms_key_arn" {
  description = "KMS Key ARN"
  value       = aws_kms_key.terraport_key.arn
}

output "kms_key_alias" {
  description = "KMS Key Alias"
  value       = aws_kms_alias.terraport_key_alias.name
} 