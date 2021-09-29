resource "aws_lambda_function" "hello_world" {
    function_name       = "HelloWorld"
    s3_bucket           = aws_s3_bucket.lambda_bucket.id
    s3_key              = aws_s3_bucket_object.lambda_hello_world.key
    runtime             = "go1.x"
    handler             = "hello-world"
    source_code_hash    = data.archive_file.lambda_code_hello_world.output_base64sha256
    role                = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
    name                = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
    retention_in_days   = 30
}

data "aws_iam_policy_document" "policy_document" {
    statement {
        sid     = "GetSecurityCredentials"
        actions = ["sts:AssumeRole"]
        effect  = "Allow"
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "lambda_exec" {
    name                = "lambdarole-taller-seguridad"
    path                = "/dev-service-role/lambda/"
    assume_role_policy  = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role       = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
