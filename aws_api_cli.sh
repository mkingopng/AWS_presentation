#####
# I've tended to work from the console of API gateway. I got frustrated with the CLI
#####

# list APIs
aws apigateway get-rest-apis --region ap-southeast-2

# create the API gateway
aws apigateway create-rest-api --name 'Python_REST_API' --description 'API for testing Python Lambda' --region 'ap-southeast-2'

# this needs to be updated for correct API resource id, if new one is made

# get the root resource ID
aws apigateway get-resources --rest-api-id gnoqjcvs5c

# create the API resource
aws apigateway create-resource --rest-api-id gnoqjcvs5c --parent-id mz3egynww5 --path-part 'python-resource'

# create the post method
aws apigateway put-method --rest-api-id gnoqjcvs5c --resource-id 64w3il --http-method POST --authorization-type NONE
aws apigateway put-integration --rest-api-id gnoqjcvs5c --resource-id 64w3il --http-method POST --type AWS_PROXY --integration-http-method POST --uri arn:aws:apigateway:ap-southeast-2:lambda:path/2015-03-31/functions/arn:aws:lambda:001499655372:function:python-lambda/invocations
aws apigateway put-method-response --rest-api-id gnoqjcvs5c --resource-id 64w3il --http-method POST --status-code 200
aws apigateway put-integration-response --rest-api-id gnoqjcvs5c --resource-id <64w3il --http-method POST --status-code 200 --response-templates '{"application/json": ""}'

# create the get method
aws apigateway put-method --rest-api-id gnoqjcvs5c --resource-id 64w3il --http-method GET --authorization-type NONE
aws apigateway put-integration --rest-api-id gnoqjcvs5c --resource-id 64w3il --http-method GET --type AWS_PROXY --integration-http-method GET --uri arn:aws:apigateway:ap-southeast-2:lambda:path/2015-03-31/functions/arn:aws:lambda:001499655372:function:python-lambda/invocations
aws apigateway put-method-response --rest-api-id gnoqjcvs5c --resource-id 64w3il --http-method GET --status-code 200
aws apigateway put-integration-response --rest-api-id gnoqjcvs5c --resource-id 64w3il --http-method GET --status-code 200 --response-templates '{"application/json": ""}'


# deploy the API
aws apigateway create-deployment --rest-api-id gnoqjcvs5c --stage-name dev

# test the endpoints for post method
curl -X POST https://gnoqjcvs5c.execute-api.ap-southeast-2.amazonaws.com/dev/python-resource

# test the endpoints for the get method
curl -X GET https://gnoqjcvs5c.execute-api.ap-southeast-2.amazonaws.com/dev/python-resource

#