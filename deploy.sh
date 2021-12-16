#!/bin/bash
       
cd lambda

# For first function       
# Check if function exists or not and proceed accordingly

timeout 10 aws lambda wait function-exists --function-name roshan-rimal-hello

# Check if the return code of the above command is 0.

if [ $? -eq 0 ]
then

# function exists redeploy the zip package
aws lambda update-function-code  --function-name roshan-rimal-hello \
--zip-file fileb://package.zip

else

# function doesn't exist need to create role, attach permission then create function
# and deploy the package

# creates a role
ARN=$(aws iam create-role --role-name roshan-rimal-hello-lambda-role --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'  | jq '.Role.Arn')
	
# attaches permissions to the role
aws iam attach-role-policy --role-name roshan-rimal-hello-lambda-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# finally create the function 
aws lambda create-function --function-name roshan-rimal-hello \
--zip-file fileb://package.zip --handler hello.handler --runtime python3.9 \
--role $ARN

fi

# For second function
# Check if function exists or not and proceed accordingly

timeout 10 aws lambda wait function-exists --function-name roshan-rimal-hello-dynamic

# Check if the return code of the above command is 0.

if [ $? -eq 0 ]
then

# function exists redeploy the zip package
aws lambda update-function-code  --function-name roshan-rimal-hello-dynamic \
--zip-file fileb://package-dynamic.zip

else

# function doesn't exist need to create role, attach permission then create function
# and deploy the package

# creates a role and attach permission to the role
# then extract the role ARN 
ARN=$(aws iam create-role --role-name roshan-rimal-hello-lambda-role --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'  | jq '.Role.Arn')

# attaches permissions to the above role 
aws iam attach-role-policy --role-name roshan-rimal-hello-lambda-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# finally create the function 
aws lambda create-function --function-name roshan-rimal-hello-dynamic \
--zip-file fileb://package-dynamic.zip --handler hello-dynamic.handler --runtime python3.9 \
--role $ARN

fi
