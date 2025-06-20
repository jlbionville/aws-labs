 data "archive_file" "lambda_list" {
          type        = "zip"
          source_file = "${path.module}/../lambda/get_all.py"
          output_path = "${path.module}/../lambda/get_all.zip"
        }

        resource "aws_lambda_function" "list_bookmarks" {
          function_name    = "list_bookmarks"
          filename         = data.archive_file.lambda_list.output_path
          source_code_hash = data.archive_file.lambda_list.output_base64sha256
          handler          = "get_all.handler"
          runtime          = "python3.12"
          role             = aws_iam_role.lambda_exec.arn
          environment {
            variables = {
              TABLE_NAME = aws_dynamodb_table.bookmarks.name
            }
          }
        }