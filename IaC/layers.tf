resource "aws_s3_bucket_object" "layer_aws_sdk" {
    bucket    = aws_s3_bucket.lambda_bucket.id

    key       = "aws_sdk_layer.zip"
    source    = abspath("${path.root}/../services/layers/aws_sdk/aws-sdk-layer.zip")

    etag      = filemd5(abspath("${path.root}/../services/layers/aws_sdk/aws-sdk-layer.zip"))
}

resource "aws_lambda_layer_version" "aws_sdk" {
    layer_name = "aws_sdk_layer"
    compatible_runtimes = ["nodejs14.x"]
    s3_bucket           = aws_s3_bucket.lambda_bucket.id
    s3_key              = aws_s3_bucket_object.layer_aws_sdk.key
    source_code_hash    = filebase64sha256(abspath("${path.root}/../services/layers/aws_sdk/aws-sdk-layer.zip"))
}