output "post_bookmark_url" {
  value = "${aws_api_gateway_deployment.deploy.invoke_url}/bookmarks"
}