variable "name_vpc" {
  type    = string
  default = "vpc"
}

variable "tags" {
  type = map(any)
}

variable "bucket_name" {
  type    = string
  default = "s3name"
}

variable "aws_lambda_function_name" {
  type    = string
  default = "lamnbda_challenge"
}

variable "role_lambda" {
  type    = string
  default = "lambda_role"
}


variable "app_version" {
  type    = string
  default = "v1.0.0"
}
