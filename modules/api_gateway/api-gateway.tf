# # API Gateway
# resource "aws_api_gateway_rest_api" "main" {
#   name = "${var.project_name}-api"
# }

# # API Gateway Resource
# resource "aws_api_gateway_resource" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   parent_id   = aws_api_gateway_rest_api.main.root_resource_id
#   path_part   = "{proxy+}"
# }

# # API Gateway Method
# resource "aws_api_gateway_method" "proxy" {
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   resource_id   = aws_api_gateway_resource.proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# # API Gateway Integration
# resource "aws_api_gateway_integration" "lambda" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.proxy.id
#   http_method = aws_api_gateway_method.proxy.http_method

#   integration_http_method = "POST"
#   type                   = "AWS_PROXY"
#   uri                    = aws_lambda_function.main.invoke_arn
# }

# # Lambda Permission for API Gateway
# resource "aws_lambda_permission" "apigw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.main.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
# }

# # API Gateway Deployment
# resource "aws_api_gateway_deployment" "main" {
#   depends_on = [
#     aws_api_gateway_integration.lambda,
#   ]

#   rest_api_id = aws_api_gateway_rest_api.main.id
#   stage_name  = "prod"
# }

# # API Gateway Stage
# resource "aws_api_gateway_stage" "main" {
#   deployment_id = aws_api_gateway_deployment.main.id
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   stage_name    = "prod"
# } 