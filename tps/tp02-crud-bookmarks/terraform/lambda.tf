data "archive_file" "lambda_create" {
  type        = "zip"
  source_file = "${path.module}/../lambda/create.py"
  output_path = "${path.module}/../lambda/create.zip"
}

resource "aws_lambda_function" "create_bookmark" {
  function_name = "create_bookmark"
  filename      = data.archive_file.lambda_create.output_path
  source_code_hash = data.archive_file.lambda_create.output_base64sha256
  handler       = "create.handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.bookmarks.name
    }
  }
}