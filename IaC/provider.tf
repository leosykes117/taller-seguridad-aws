provider "aws" {
    profile = var.aws_profile
    region = var.aws_region
    shared_credentials_file = "/home/terraform/.aws/credentials"

    default_tags {
        tags = {
            Project = "taller-seguridad"
            Env     = var.aws_env
        }
    }
}
