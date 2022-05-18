import json
import boto3

s3_client = boto3.client("s3")
S3_BUCKET = 'challengedevopsjack'

#principal function challenge
def lambda_handler(event, context):
    data = s3_client.get_object(Bucket=S3_BUCKET, Key='texto.txt')
    contents = data['Body'].read()


    message = {
        'message': contents.decode("utf-8")
    }
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(message)
    }
