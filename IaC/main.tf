resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "lambda-code-taller-seguridad"

    acl           = "private"
    force_destroy = true

    tags = {
        Name = "lambda-code-taller-seguridad"
        Description = "Bucket para alogar el código de las funciones lambda"
    }
}

data "archive_file" "lambda_code_hello_world" {
    type        = "zip"
    source_file = abspath("${path.root}/../services/hello-world/bin/hello-world")
    output_path = abspath("${path.root}/../services/hello-world/bin/hello-world.zip")
}

resource "aws_s3_bucket_object" "lambda_hello_world" {
    bucket    = aws_s3_bucket.lambda_bucket.id

    key       = "hello-world.zip"
    source    = data.archive_file.lambda_code_hello_world.output_path

    etag      = filemd5(data.archive_file.lambda_code_hello_world.output_path)
}
