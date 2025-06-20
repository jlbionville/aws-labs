terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 5.0"
}
}
}

provider "aws" {
region = "eu-west-1"
}

resource "aws_iam_role" "lambda_exec" {
name = "lambda_exec_role_tp01"
assume_role_policy = jsonencode({
Version = "2012-10-17",
Statement = [{
Effect = "Allow",
Principal = {
Service = "lambda.amazonaws.com"
},
Action = "sts:AssumeRole"
}]
})
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
role = aws_iam_role.lambda_exec.name
policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
type = "zip"
source_file = "${path.module}/../lambda/ping.py"
output_path = "${path.module}/../lambda/ping.zip"
}

resource "aws_lambda_function" "ping" {
function_name = "tp01-ping"
handler = "ping.handler"
runtime = "python3.12"
role = aws_iam_role.lambda_exec.arn
filename = data.archive_file.lambda_zip.output_path
source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_api_gateway_rest_api" "api" {
name = "tp01-bookmarks-api"
}

resource "aws_api_gateway_resource" "ping" {
rest_api_id = aws_api_gateway_rest_api.api.id
parent_id = aws_api_gateway_rest_api.api.root_resource_id
path_part = "ping"
}

resource "aws_api_gateway_method" "ping" {
rest_api_id = aws_api_gateway_rest_api.api.id
resource_id = aws_api_gateway_resource.ping.id
http_method = "GET"
authorization = "NONE"
}

resource "aws_api_gateway_integration" "ping" {
rest_api_id = aws_api_gateway_rest_api.api.id
resource_id = aws_api_gateway_resource.ping.id
http_method = aws_api_gateway_method.ping.http_method
integration_http_method = "POST"
type = "AWS_PROXY"
uri = aws_lambda_function.ping.invoke_arn
}

resource "aws_lambda_permission" "api_gw" {
statement_id = "AllowExecutionFromAPIGateway"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.ping.function_name
principal = "apigateway.amazonaws.com"
source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deploy" {
depends_on = [aws_api_gateway_integration.ping]
rest_api_id = aws_api_gateway_rest_api.api.id
stage_name = "dev"
}

output "invoke_url" {
value = "${aws_api_gateway_deployment.deploy.invoke_url}/ping"
}