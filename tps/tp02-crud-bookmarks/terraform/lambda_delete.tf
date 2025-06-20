data "archive_file" "lambda_delete" {
          type        = "zip"
          source_file = "${path.module}/../lambda/delete.py"
          output_path = "${path.module}/../lambda/delete.zip"
        }

        resource "aws_lambda_function" "delete_bookmark" {
          function_name    = "delete_bookmark"
          filename         = data.archive_file.lambda_delete.output_path
          source_code_hash = data.archive_file.lambda_delete.output_base64sha256
          handler          = "delete.handler"
          runtime          = "python3.12"
          role             = aws_iam_role.lambda_exec.arn
          environment {
            variables = {
              TABLE_NAME = aws_dynamodb_table.bookmarks.name
            }
          }
        }