resource "aws_cognito_user_pool" "pool" {
    name                        = "userpool-taller-seguridad"
    auto_verified_attributes    = ["email"]
    username_attributes         = [ "email" ]
}

resource "aws_cognito_user_pool_client" "client" {
    name = "appclient-taller-seguridad"
    user_pool_id = aws_cognito_user_pool.pool.id
    explicit_auth_flows = [
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH"
    ]
}