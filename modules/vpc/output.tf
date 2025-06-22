output "vpc_id" {
    value = aws_vpc.main.id
}

output "aws_public_subnet_id" {
    description = "aws public subnet ids"
    value       = aws_subnet.public[*].id
}

output "vpc_cidr_blocks" {
    description = "vpc cidr blocks"
    value       = aws_vpc.main.cidr_block
}