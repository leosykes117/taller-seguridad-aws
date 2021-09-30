# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value       = aws_s3_bucket.lambda_bucket.id
}

output "lambda_sign_up_function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.sign_up.function_name
}

output "pool_id" {
  description = "Id del grupo de usuarios de cognito."
  value       = aws_cognito_user_pool.pool.id
}

output "client_id" {
  description = "Id del app client de cognito."
  value       = aws_cognito_user_pool_client.client.id
}

output "base_url" {
  description = "URL base del stage de API Gateway."
  value       = aws_apigatewayv2_stage.lambda.invoke_url
}