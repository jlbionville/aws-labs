# Resource /bookmarks already defined in apigateway.tf
# Add GET /bookmarks
resource "aws_api_gateway_method" "get_bookmarks" {
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  resource_id = aws_api_gateway_resource.bookmarks.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_bookmarks" {
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  resource_id = aws_api_gateway_resource.bookmarks.id
  http_method = aws_api_gateway_method.get_bookmarks.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = aws_lambda_function.list_bookmarks.invoke_arn
}

# Resource /bookmarks/{id}
resource "aws_api_gateway_resource" "bookmark_id" {
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  parent_id   = aws_api_gateway_resource.bookmarks.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_bookmark" {
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  resource_id = aws_api_gateway_resource.bookmark_id.id
  http_method = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "get_bookmark" {
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  resource_id = aws_api_gateway_resource.bookmark_id.id
  http_method = aws_api_gateway_method.get_bookmark.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = aws_lambda_function.get_bookmark.invoke_arn
  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

resource "aws_api_gateway_method" "delete_bookmark" {
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  resource_id = aws_api_gateway_resource.bookmark_id.id
  http_method = "DELETE"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "delete_bookmark" {
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  resource_id = aws_api_gateway_resource.bookmark_id.id
  http_method = aws_api_gateway_method.delete_bookmark.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = aws_lambda_function.delete_bookmark.invoke_arn
  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

# Permissions for new lambdas
resource "aws_lambda_permission" "api_gw_list" {
  statement_id  = "AllowExecutionFromAPIGatewayList"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_bookmarks.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.bookmarks_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gw_get" {
  statement_id  = "AllowExecutionFromAPIGatewayGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_bookmark.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.bookmarks_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gw_delete" {
  statement_id  = "AllowExecutionFromAPIGatewayDelete"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_bookmark.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.bookmarks_api.execution_arn}/*/*"
}

# Update deployment depends_on reference
resource "aws_api_gateway_deployment" "deploy" {
  depends_on = [
    aws_api_gateway_integration.post_bookmark,
    aws_api_gateway_integration.get_bookmarks,
    aws_api_gateway_integration.get_bookmark,
    aws_api_gateway_integration.delete_bookmark
  ]
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  stage_name  = "dev"
}

