#!/bin/bash

mkdir -p python_lambda_package
cd python_lambda_package || exit

# export requirements from poetry pyproject.toml
poetry export -f requirements.txt --output requirements.txt

# Install dependencies to a target directory
pip install -r requirements.txt -t .

# Copy the lambda function code
cp ./../src/python_lambda.py .

# Zip the function code and dependencies
zip -r python_lambda.zip .

# create
aws lambda create-function --function-name python-lambda --runtime python3.12 --role arn:aws:iam::001499655372:role/Rust-vs-Python-project --handler python_lambda.lambda_handler --zip-file fileb://python_lambda.zip

# update the function code
#aws lambda update-function-code --function-name python-lambda --zip-file fileb://python_lambda.zip
