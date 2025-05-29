resource "aws_lambda_function" "this" {
  function_name = this_lambda
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = data.archive_file.lambda_zip.output_path
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.security_group_ids
  }
}

resource "aws_lambda_function" "this_second" {
  function_name = this_second_lambda
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = data.archive_file.lambda_zip.output_path
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.security_group_ids
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_lambda1"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../${var.function_name}"
  output_path = "${path.module}/../../${var.function_name}.zip"
}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}

variable "function_name" {}
variable "vpc_subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
