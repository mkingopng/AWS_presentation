"""
The AWS Lambda function written in Python performs the following tasks:
    - Generate a UUID: create a unique identifier (UUID).
    - Store Data in S3: The UUID is converted to bytes and stored in an S3
    bucket as a file with the UUID as the filename.
    - Store Data in DynamoDB: The UUID is also stored in a DynamoDB table
    as an item with the key "id" set to the UUID value.
    - Return a JSON Response: Finally, it returns a JSON response
    containing the UUID.
It serves as an example of integrating AWS services (S3 and DynamoDB) using
Python, demonstrating basic operations like storing and retrieving data.
"""
import os
import json
import logging
import boto3
import uuid

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')
dynamo_client = boto3.client('dynamodb')


def lambda_handler(event, context):
    """

    :param event:
    :param context:
    :return:
    """
    # read environment variables for S3 bucket name and DynamoDB table name
    s3_bucket_name = os.getenv('S3_BUCKET_NAME')
    dynamo_table_name = os.getenv('DYNAMODB_TABLE')

    if not s3_bucket_name or not dynamo_table_name:
        logger.error('Environment variables S3_BUCKET_NAME and DYNAMODB_TABLE must be set')
        raise ValueError('Missing environment variables')

    # generate a new UUID
    guid = str(uuid.uuid4())
    file_name = f"{guid}.txt"
    encoded_string = guid.encode()

    # put the encoded UUID into the S3 bucket
    try:
        s3_client.put_object(Bucket=s3_bucket_name, Key=file_name, Body=encoded_string)
        logger.info('Successfully put object in S3')
    except Exception as e:
        logger.error(f'Failed to put object in S3: {e}')
        raise

    # put the UUID into the DynamoDB table
    try:
        dynamo_client.put_item(
            TableName=dynamo_table_name,
            Item={'id': {'S': guid}}
        )
        logger.info('Successfully put item in DynamoDB')
    except Exception as e:
        logger.error(f'Failed to put item in DynamoDB: {e}')
        raise

    return {
        'statusCode': 200,
        'body': json.dumps({'id': guid})
    }
