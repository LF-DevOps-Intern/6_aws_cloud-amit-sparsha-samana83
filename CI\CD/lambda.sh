#!/bin/bash

cd /home/samana/lambda_functions

# Create zip packages for the deployment 
zip package.zip hello.py
zip package_dynamic.zip hello_dynamic.py

# For first function redeploy the zip package
aws lambda update-function-code  --function-name samana_lambda_hello \
--zip-file fileb://package.zip


# For second function
aws lambda update-function-code  --function-name samana_hello_dynamic \
--zip-file fileb://package_dynamic.zip


