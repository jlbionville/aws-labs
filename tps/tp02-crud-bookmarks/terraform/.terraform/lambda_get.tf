 data "archive_file" "lambda_get" {
          type        = "zip"
          source_file = "${path.module}/../lambda/get_one.py"
          output_path = "${path.module}/../lambda/get_one.zip"
        }

        resource "aws_lambda_function" "get_bookmark" {
          function_name    = "get_bookmark"
          filename         = data.archive_file.lambda_get.output_path
          source_code_hash = data.archive_file.lambda_get.output_base64sha256
          handler          = "get_one.handler"
          runtime          = "python3.12"
          role             = aws_iam_role.lambda_exec.arn
          environment {
            variables = {
              TABLE_NAME = aws_dynamodb_table.bookmarks.name
            }
          }
        }