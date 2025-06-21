# Lambda Function
resource "aws_lambda_function" "main" {
  filename         = "lambda_function_ec2.zip"
  function_name    = "${var.project_name}-function-ec2"
  role            = aws_iam_role.lambda_role.arn
  handler         = "terraport_main_ec2.terraport_main_ec2"
  runtime         = "python3.12"
  timeout         = 30
  tags = {
    Name = "${var.project_name}-lambda-ec2"
    Project = var.project_name
  }

  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      PYTHONPATH = "/var/task"
    }
  }
} 