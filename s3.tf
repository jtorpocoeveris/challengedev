resource "aws_s3_bucket" "s3challenge" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = var.tags
}

// Upload texto.txt
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.s3challenge.id
  key    = "texto.txt"
  acl    = "private" # or can be "public-read"
  source = "texto.txt"
  etag   = filemd5("texto.txt")

}


resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3challenge.id
  versioning_configuration {
    status = "Enabled"
  }
}