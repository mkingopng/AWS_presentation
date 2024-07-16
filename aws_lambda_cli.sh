#!/bin/bash

mkdir -p python_lambda_package
cd python_lambda_package || exit

# export requirements from poetry pyproject.toml
poetry export -f requirements.txt --output requirements.txt

# install dependencies to a target directory
pip install -r requirements.txt -t .

# copy the lambda function code
cp ./../src/main.py .

# zip the function code and dependencies
zip -r main.zip .

# delete the existing Lambda function if it exists
aws lambda delete-function --function-name python-lambda

# Create the Lambda function
aws lambda create-function --function-name python-lambda \
    --runtime python3.12 \
    --role arn:aws:iam::001499655372:role/Rust-vs-Python-project \
    --handler main.lambda_handler \
    --zip-file fileb://main.zip

# update the lambda function
aws lambda update-function-code --function-name python-lambda --zip-file fileb://python_lambda.zip

# update the environment variables
aws lambda update-function-configuration \
    --function-name python-lambda \
    --environment Variables="{S3_BUCKET_NAME=snakey-bucket,DYNAMODB_TABLE=snakey-table}"

