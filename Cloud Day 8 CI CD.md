# Cloud Day 8 CI CD

### Tasks:

1. Create a bash script to deploy your lambda functions
2. Create a bash script to deploy your react app to S3
3. Integrate both these scripts with one of Jenkins, Github Actions, CircleCI or TravisCI

### Resources Used:

Region: `us-east-1a`

Function 1 Name: `roshan-rimal-hello` 

Function 1 ARN: `arn:aws:lambda:us-east-1:949263681218:function:roshan-rimal-hello` 

Function 2 Name : `roshan-rimal-hello-dynamic`

Function 2 ARN: `arn:aws:lambda:us-east-1:949263681218:function:roshan-rimal-hello-dynamic`

Bucket Name: `roshan-rimal-static-cloudfront-site` 

Bucket ARN: `arn:aws:s3:::roshan-rimal-static-cloudfront-site` 

## Q.1.

1. Create a bash script named `deploy.sh`  with the following content to deploy the functions 

```jsx
#!/bin/bash

cd ~/lambda

# Create zip packages for the deployment regardless of whether fuctions exists or not
zip package.zip hello.py
zip package-dynamic.zip hello-dynamic.py

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
```

Testing `[deploy.sh](http://deploy.sh)` 

![Untitled](images/Untitled.png)

1. Create a bash script name `[static.sh](http://static.sh)` with the following content to deploy react app

The script has be commented throughout to provide necessary explanation

```bash
#!/bin/bash

# specify the region and the name of the bucket 
S3_BUCKET=roshan-rimal-static-cloudfront-site
REGION=us-east-1

cd react_project

# build the static react application regardless of whether bucket exists or not
npm run build

# create a directory for build artifacts if it doesn't exist
if [ ! -d ~/static-cloudfront-site ]
then

# create a directory for build artifacts
mkdir ~/static-cloudfront-site

fi

cp -R build/* ~/static-cloudfront-site/
cd ~/static-cloudfront-site

# checking if bucket exists by checking the return value of the command below
aws s3api head-bucket --bucket $S3_BUCKET

if [ $? -ne 0 ];
then
# bucket doesnt exist create it and set permissions
aws s3api create-bucket --bucket $S3_BUCKET \
                     --region $REGION

# Turn off block public access
aws s3api put-public-access-block \
    --bucket roshan-rimal-static-cloudfront-site \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# Enable static hosting for the bucket
aws s3 website s3://roshan-rimal-static-cloudfront-site --index-document index.html --error-document error.html

# Turn on block public access again to make it restrictive after creating Cloudfront distribution
aws s3api put-public-access-block \
    --bucket roshan-rimal-static-cloudfront-site \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=false"

else
#bucket exist just need to sync the build directory with S3 bucket

# Update the bucket with new build artifacts
aws s3 sync ./ s3://roshan-rimal-static-cloudfront-site

fi
```

Testing `static.sh`

![Untitled](images/Untitled%201.png)

1. Integrate with Jenkins
    
    3.1 Install Jenkins
    
    ```bash
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    ```
    

     View the service

![Untitled](images/Untitled%202.png)

      3.2 Set up Jenkins

3.2.1 Set up webhook in github

![Untitled](images/Untitled%203.png)

3.2.2  Set up Jenkins

![Untitled](images/Untitled%204.png)

3.3 Setting up build pipeline

3.3.1 Create an item

![Untitled](images/Untitled%205.png)

3.3.2 Set up repository and branch name

![Untitled](images/Untitled%206.png)

3.3.3 Set GitHub hook trigger

![Untitled](images/Untitled%207.png)

3.3.4 Test Github webhook

![Untitled](images/Untitled%208.png)

3.3.5 View Github Webhook Log

![Untitled](images/Untitled%209.png)

3.3.6 Extract the build steps from the above script into Jenkins and set Execute shell Build step

![Untitled](images/Untitled%2010.png)

The Commands are as:

```bash
cd lambda
zip package.zip hello.py
zip package-dynamic.zip hello-dynamic.py
cd ../react_project
npm install
npm run build
mkdir -p ../static-cloudfront-site
cp -R build/* ../static-cloudfront-site/
```

3.3.7 Install S3 Publisher and AWS Lambda Plugins, use them for Continuous Deployment (CD)

![Untitled](images/Untitled%2011.png)

3.3.8 Set up S3 Profile ( Dashboard > Manage Jenkins > Amazon S3 Profile > Add)

![Untitled](images/Untitled%2012.png)

3.3.9 Verify that S3 Profile has been added

![Untitled](images/Untitled%2013.png)

3.3.10  Setup Publish Artifacts to S3 bucket Post Build Action

![Untitled](images/Untitled%2014.png)

3.3.11 Setup Deploy AWS Lambda functions Post Build Action

![Untitled](images/Untitled%2015.png)

3.4 Verify that the Build Passed

3.4.1 Build Successful

![Untitled](images/Untitled%2016.png)

3.4.2 Build Successful uploaded artifacts to S3

![Untitled](images/Untitled%2017.png)

3.4.3 Build Successful deployed lambda function

![Untitled](images/Untitled%2018.png)

3.4.4 View the Embeddable Build Status

We can use the Embeddable Build Status in this document itself but since I cannot have this IP for long time it wont work but here is the screenshot:

![Untitled](images/Untitled%2019.png)

The bash scripts in Q1 and Q2 were modified for integration with Jenkins as follows:

`deploy.sh`

```bash
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
```

 

`static.sh`

```bash
#!/bin/bash

# specify the region and the name of the bucket 
S3_BUCKET=roshan-rimal-static-cloudfront-site
REGION=us-east-1

# checking if bucket exists by checking the return value of the command below
aws s3api head-bucket --bucket $S3_BUCKET

if [ $? -ne 0 ];
then
# bucket doesnt exist create it and set permissions
aws s3api create-bucket --bucket $S3_BUCKET \
                     --region $REGION

# Turn off block public access
aws s3api put-public-access-block \
    --bucket roshan-rimal-static-cloudfront-site \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# Enable static hosting for the bucket
aws s3 website s3://roshan-rimal-static-cloudfront-site --index-document index.html --error-document error.html

# Turn on block public access again to make it restrictive after creating Cloudfront distribution
aws s3api put-public-access-block \
    --bucket roshan-rimal-static-cloudfront-site \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=false"

else
#bucket exist just need to sync the build directory with S3 bucket

# Update the bucket with new build artifacts
aws s3 sync ./static-cloudfront-site s3://roshan-rimal-static-cloudfront-site

fi
```