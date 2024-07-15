#!/bin/bash

mkdir -p python_lambda_package
cd python_lambda_package || exit

# export requirements from poetry pyproject.toml
poetry export -f requirements.txt --output requirements.txt

# Install dependencies to a target directory
pip install -r requirements.txt -t .

# Copy the lambda function code
cp ./../src/main.py .

# Zip the function code and dependencies
zip -r main.zip .

# Delete the existing Lambda function if it exists
aws lambda delete-function --function-name python-lambda

# Create the Lambda function
aws lambda create-function --function-name python-lambda \
    --runtime python3.12 \
    --role arn:aws:iam::001499655372:role/Rust-vs-Python-project \
    --handler main.lambda_handler \
    --zip-file fileb://main.zip

# update the lambda function
aws lambda update-function-code --function-name python-lambda --zip-file fileb://python_lambda.zip

# Update the environment variables
aws lambda update-function-configuration \
    --function-name python-lambda \
    --environment Variables="{S3_BUCKET_NAME=snakey-bucket,DYNAMODB_TABLE=snakey-table}"

# create the API gateway
aws apigateway create-rest-api --name 'Python_REST_API' --description 'API for testing Python Lambda' --region 'ap-southeast-2'

# get the root resource ID
aws apigateway get-resources --rest-api-id 507edncmmj

# create the resource
aws apigateway create-resource --rest-api-id 507edncmmj --parent-id mz3egynww5 --path-part 'python-resource'

# create the post method
aws apigateway put-method --rest-api-id 507edncmmj --resource-id 64w3il --http-method POST --authorization-type NONE
aws apigateway put-integration --rest-api-id 507edncmmj --resource-id 64w3il --http-method POST --type AWS_PROXY --integration-http-method POST --uri arn:aws:apigateway:ap-southeast-2:lambda:path/2015-03-31/functions/arn:aws:lambda:001499655372:function:python-lambda/invocations
aws apigateway put-method-response --rest-api-id 507edncmmj --resource-id 64w3il --http-method POST --status-code 200
aws apigateway put-integration-response --rest-api-id 507edncmmj --resource-id <64w3il --http-method POST --status-code 200 --response-templates '{"application/json": ""}'

# create the get method
aws apigateway put-method --rest-api-id 507edncmmj --resource-id 64w3il --http-method GET --authorization-type NONE
aws apigateway put-integration --rest-api-id 507edncmmj --resource-id 64w3il --http-method GET --type AWS_PROXY --integration-http-method GET --uri arn:aws:apigateway:ap-southeast-2:lambda:path/2015-03-31/functions/arn:aws:lambda:001499655372:function:python-lambda/invocations
aws apigateway put-method-response --rest-api-id 507edncmmj --resource-id 64w3il --http-method GET --status-code 200
aws apigateway put-integration-response --rest-api-id 507edncmmj --resource-id 64w3il --http-method GET --status-code 200 --response-templates '{"application/json": ""}'


# deploy the API
aws apigateway create-deployment --rest-api-id 507edncmmj --stage-name dev

# test the endpoints for post method
curl -X POST https://507edncmmj.execute-api.ap-southeast-2.amazonaws.com/dev/python-resource

# test the endpoints for the get method
curl -X GET https://507edncmmj.execute-api.ap-southeast-2.amazonaws.com/dev/python-resource

#