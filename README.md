# Steps to deploy

1. create a directory for the deployment package
   ```bash
   mkdir python_lambda_package
   cd python_lambda_package
   ```

2. export the dependencies
   ```bash
   cd python_lambda_package
   poetry export -f requirements.txt --output requirements.txt
   ```

3. install the dependencies into the deployment package
   ```bash
   cd python_lambda_package
   pip install -r requirements.txt -t .
   ```

4. copy the `python_lambda.py` into the deployment package directory
   ```bash
   cd python_lambda_package
   cp ./../src/python_lambda.py .
   ```

5. create the deployment package zip file
   ```bash
   cd python_lambda_package
   zip -r python_lambda.zip .
   ```

6. deploy the lambda function using AWS CLI

   for new dpeloyment
   ```bash
   cd python_lambda_package
   aws lambda create-function --function-name python-lambda \
     --runtime python3.12 --role arn:aws:iam::001499655372:role/Rust-vs-Python-project \
     --handler lambda_function.lambda_handler --zip-file fileb://python_lambda.zip \
     --environment Variables="{S3_BUCKET_NAME=snakey-bucket,
     DYNAMODB_TABLE=snakey-table}"
   ```

   to update
   ```bash
   cd python_lambda_package
   aws lambda update-function-code --function-name python-lambda --zip-file fileb://python_lambda.zip
   aws lambda update-function-configuration --function-name python-lambda --handler python_lambda.lambda_handler
   ```

7. test the lambda function
   ```bash
   aws lambda invoke --function-name python-lambda --payload '{}' response.json
   cat output.json
   ```

