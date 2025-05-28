provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-lab-bucket-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "lambda1" {
  source             = "./modules/lambda"
  function_name      = "lambda1"
  vpc_subnet_ids     = module.vpc.private_subnets
  security_group_ids = [module.vpc.lambda_sg]
}

module "lambda2" {
  source             = "./modules/lambda"
  function_name      = "lambda2"
  vpc_subnet_ids     = module.vpc.private_subnets
  security_group_ids = [module.vpc.lambda_sg]
}

module "apigw1" {
  source          = "./modules/apigateway"
  lambda_function = module.lambda1.lambda_arn
}

module "apigw2" {
  source          = "./modules/apigateway"
  lambda_function = module.lambda2.lambda_arn
}