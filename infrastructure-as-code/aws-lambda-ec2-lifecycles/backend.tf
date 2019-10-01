terraform {
  backend "s3" {
    bucket         = "vkvtest-tf"
    key            = "dev/vkvtest.tfstate"
    region         = "us-east-1"
    dynamodb_table = "vkvtest-us-east-1-tf"
    profile        = "default"
  }
}
