# Zip the Lamda function on the fly
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "application"
  output_path = "application.zip"
}

resource "aws_s3_bucket_object" "object_application" {

  bucket = aws_s3_bucket.s3challenge.id
  key    = "${var.app_version}/example.zip"
  acl    = "private" # or can be "public-read"
  source = "application.zip"
}





resource "aws_lambda_function" "challenge" {
  function_name = var.aws_lambda_function_name

  # El nombre del depósito como se creó anteriormente con "aws s3api create-bucket"
  s3_bucket = var.bucket_name
  s3_key    = "${var.app_version}/example.zip"

  # "main" es el nombre del archivo dentro del archivo zip (main.js) y "handler"
  # es el nombre de la propiedad bajo la cual se encontraba la función de controlador
  # exportado en ese archivo.
  handler       = "main.lambda_handler"

  runtime       = "python3.9"

  role = aws_iam_role.lambda_exec.arn


  vpc_config {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [aws_default_security_group.default_security_group.id]
  }

  depends_on = [aws_s3_bucket_object.object_application]

}

# Rol de IAM que dicta qué otros servicios de AWS ofrece la función Lambda.
# puede acceder.
resource "aws_iam_role" "lambda_exec" {
  name = var.role_lambda

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}



#Created Policy for IAM Role
resource "aws_iam_policy" "policy" {
  name        = "s3access-test-policy"
  description = "A test policy"


  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": "arn:aws:s3:::*"
    }
]
} 
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.policy.arn
}