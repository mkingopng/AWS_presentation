"""
This code is borrowed from Illya Kavaliu's presentation at Brisbane Serverless Meetup
https://github.com/ikavaliou-mg/lambda-ec2-ecs-comparison/tree/main
"""
import boto3
import uuid
import os
import json
from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()
s3 = boto3.resource("s3")
dynamo_db = boto3.resource("dynamodb")


@app.post("/process-request")
def process_request():
    """
    Handle POST request to process and store data.

    This function generates a unique identifier (GUID), encodes it, and stores it
    as a text file in an S3 bucket. Additionally, it saves the GUID in a DynamoDB table.

    :return: A dictionary containing the generated GUID.
    """
    print("Processing request...")
    bucket_name = os.environ["S3_BUCKET_NAME"]
    ddb_table = os.environ["DYNAMODB_TABLE"]
    print(f"S3_BUCKET_NAME: {bucket_name}")
    print(f"DYNAMODB_TABLE: {ddb_table}")
    try:
        guid = str(uuid.uuid4())
        encoded_string = guid.encode("utf-8")
        file_name = f"{guid}.txt"
        s3.Bucket(bucket_name).put_object(Key=file_name, Body=encoded_string)
        table = dynamo_db.Table(ddb_table)
        table.put_item(Item={"id": guid})
        print("Request processed.")
        return {"id": guid}
    except Exception as e:
        print(f"Error: {str(e)}")
        raise e


@app.get("/health")
def health_check():
    """
    Check the health status of the application.

    :return: A dictionary indicating the health status of the application.
    """
    return {"status": "healthy"}


handler = Mangum(app, lifespan="off")


def lambda_handler(event, context):
    """
    Handle the Lambda function invocation.

    This function is the entry point for the Lambda function. It uses the
    Mangum adapter to handle the event and context from AWS Lambda and route it
    to the FastAPI application.

    :param event: The event data from AWS Lambda.
    :param context: The context data from AWS Lambda.
    :return: The response from the FastAPI application.
    """
    print("Event:", json.dumps(event, indent=2))
    return handler(event, context)


if __name__ == "__main__":
    os.environ["S3_BUCKET_NAME"] = "snakey-s3"
    os.environ["DYNAMODB_TABLE"] = "snakey-table"
    process_request()
