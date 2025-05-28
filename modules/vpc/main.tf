resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  vpc_id      = aws_vpc.lab_vpc.id
  description = "Allow Lambda to access VPC resources"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "lambda_sg" {
  value = aws_security_group.lambda_sg.id
}