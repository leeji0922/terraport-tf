# # Lambda Functions

# # EC2 관련 람다 함수
# resource "aws_lambda_function" "ec2_function" {
#   filename         = "lambda_ec2.zip"
#   function_name    = "${var.project_name}-function-ec2"
#   role            = aws_iam_role.lambda_role.arn
#   handler         = "terraport_main_ec2.terraport_main_ec2"
#   runtime         = "python3.12"
#   timeout         = 30
#   tags = {
#     Name = "${var.project_name}-lambda-ec2"
#     Project = var.project_name
#   }

#   vpc_config {
#     subnet_ids         = aws_subnet.private[*].id
#     security_group_ids = [aws_security_group.lambda.id]
#   }

#   environment {
#     variables = {
#       PYTHONPATH = "/var/task"
#     }
#   }
# }

# # 서브넷 목록 조회 람다 함수
# resource "aws_lambda_function" "subnet_list_function" {
#   filename         = "lambda_subnet_list.zip"
#   function_name    = "${var.project_name}-function-subnet-list"
#   role            = aws_iam_role.lambda_role.arn
#   handler         = "get_subnet_list.get_subnet_list"
#   runtime         = "python3.12"
#   timeout         = 30
#   tags = {
#     Name = "${var.project_name}-lambda-subnet-list"
#     Project = var.project_name
#   }

#   vpc_config {
#     subnet_ids         = aws_subnet.private[*].id
#     security_group_ids = [aws_security_group.lambda.id]
#   }

#   environment {
#     variables = {
#       PYTHONPATH = "/var/task"
#     }
#   }
# } 