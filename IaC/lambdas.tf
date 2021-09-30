resource "aws_lambda_function" "sign_up" {
    function_name       = "SignUp"
    description         = "Función encargada de realizar el registro de usuarios hacia Cognito"
    s3_bucket           = aws_s3_bucket.lambda_bucket.id
    s3_key              = aws_s3_bucket_object.lambda_code_sign_up.key
    runtime             = "nodejs14.x"
    handler             = "signin_handler.handler"
    source_code_hash    = data.archive_file.lambda_package_sign_up.output_base64sha256
    role                = aws_iam_role.lambda_auth.arn
    layers              = [aws_lambda_layer_version.aws_sdk.arn]
    environment {
      variables = {
          COGNITO_CLIENT_ID = aws_cognito_user_pool_client.client.id
      }
    }

    depends_on = [aws_cognito_user_pool_client.client]
}

resource "aws_cloudwatch_log_group" "sign_up" {
    name                = "/aws/lambda/${aws_lambda_function.sign_up.function_name}"
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
    description         = "Role encargado de la ejecución básica de lambda"
    path                = "/dev-service-role/lambda/"
    assume_role_policy  = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role       = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "cognito_auth_permissions" {
    statement {
        sid     = "AllowCognitoAuthentication"
        actions = [
            "cognito-idp:SignUp",
            "cognito-idp:InitiateAuth",
        ]
        effect  = "Allow"
        resources = [
            aws_cognito_user_pool.pool.arn
        ]
    }
}

resource "aws_iam_role" "lambda_auth" {
    name                = "lambda-role-authorizer"
    description         = "Role encargado de realizar la autenticación con cognito"
    assume_role_policy  = data.aws_iam_policy_document.policy_document.json
    inline_policy {
        name      = "lambda-cognito-authorizer"
        policy    = data.aws_iam_policy_document.cognito_auth_permissions.json
    }
}

resource "aws_iam_role_policy_attachment" "lambda_role_authorizer_basic_exec" {
    role       = aws_iam_role.lambda_auth.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
