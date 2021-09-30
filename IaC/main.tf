resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "lambda-code-taller-seguridad"

    acl           = "private"
    force_destroy = true

    tags = {
        Name = "lambda-code-taller-seguridad"
        Description = "Bucket para alogar el código de las funciones lambda"
    }
}

data "archive_file" "lambda_package_sign_up" {
    type        = "zip"
    output_path = abspath("${path.root}/../services/auth/signup.zip")
    source {
        content = file("${abspath("${path.root}/../services/auth/modules/signup/index.js")}")
        filename = "modules/signup/index.js"
    }
    source {
        content = file("${abspath("${path.root}/../services/auth/signup_handler.js")}")
        filename = "signin_handler.js"
    }
}

resource "aws_s3_bucket_object" "lambda_code_sign_up" {
    bucket    = aws_s3_bucket.lambda_bucket.id

    key       = basename(data.archive_file.lambda_package_sign_up.output_path)
    source    = data.archive_file.lambda_package_sign_up.output_path

    etag      = filemd5(data.archive_file.lambda_package_sign_up.output_path)
}
