resource "aws_api_gateway_rest_api" "bookmarks_api" {
  name = "bookmarks-api"
}

resource "aws_api_gateway_resource" "bookmarks" {
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  parent_id   = aws_api_gateway_rest_api.bookmarks_api.root_resource_id
  path_part   = "bookmarks"
}

resource "aws_api_gateway_method" "post_bookmark" {
  rest_api_id   = aws_api_gateway_rest_api.bookmarks_api.id
  resource_id   = aws_api_gateway_resource.bookmarks.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_bookmark" {
  rest_api_id             = aws_api_gateway_rest_api.bookmarks_api.id
  resource_id             = aws_api_gateway_resource.bookmarks.id
  http_method             = aws_api_gateway_method.post_bookmark.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_bookmark.invoke_arn
}

resource "aws_lambda_permission" "api_gw_post" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_bookmark.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.bookmarks_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deploy" {
  depends_on = [aws_api_gateway_integration.post_bookmark]
  rest_api_id = aws_api_gateway_rest_api.bookmarks_api.id
  stage_name  = "dev"
}