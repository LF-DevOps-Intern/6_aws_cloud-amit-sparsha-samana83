# Cloud Day 8 API Gateway

### Tasks:

1. Create two Lambda Functions
2. First Lambda function returns 200 Response as {“Hello”: “Default”}
3. Second Lambda function returns 200 Response as{“Hello”: “{Dynamic route name}”}
4. Configure API Gateway with that hits first lambda function on / and the second lambda function on /*

### Resources Used:

Region: `us-east-1a`

Function 1 Name: `roshan-rimal-hello` 

Function 1 ARN: `arn:aws:lambda:us-east-1:949263681218:function:roshan-rimal-hello` 

Function 2 Name : `roshan-rimal-hello-dynamic`

Function 2 ARN: `arn:aws:lambda:us-east-1:949263681218:function:roshan-rimal-hello-dynamic`

API Gateway Name: [`roshan-rimal-http-api-gateway`](https://console.aws.amazon.com/apigateway/main/api-detail?api=maotjwfkeb&region=us-east-1&stage=unselected)

API Gateway Invoke URL: [`https://maotjwfkeb.execute-api.us-east-1.amazonaws.com`](https://maotjwfkeb.execute-api.us-east-1.amazonaws.com/)

## Q.1,2,3.

1.1 Create a Lambda function `roshan-rimal-hello` that returns `{"Hello":"Default"}`

1.1.1 Create a source file `[hello.py](http://hello.py)` with the following content

```bash
import json
def handler(event,context):
		response={"Hello":"Default"}
    return {
        'statusCode': 200,
				'headers': {'Content-Type': 'application/json'},
        'body': json.dumps(response)
    } 
```

1.1.2 Create zip deployment

```bash
zip package.zip hello.py
```

![Untitled](images/apigateway/Untitled.png)

1.1.3 Create lambda function

1.1.3.1 Create a Role and attach `LambdaBasicExecutionRole` permissions policy to it

```bash
# creates a role
aws iam create-role --role-name roshan-rimal-hello-lambda-role --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'
	
# attaches permissions to the role
aws iam attach-role-policy --role-name roshan-rimal-hello-lambda-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
```

![Untitled](images/apigateway/Untitled%201.png)

Note the Role's `arn` and use it below.

Role's ARN is `arn:aws:iam::949263681218:role/roshan-rimal-hello-lambda-role`

1.1.3.2 Create the lambda function and deploy the `zip` package

```bash
aws lambda create-function --function-name roshan-rimal-hello \
--zip-file fileb://package.zip --handler hello.handler --runtime python3.9 \
--role arn:aws:iam::949263681218:role/roshan-rimal-hello-lambda-role
```

 

![Untitled](images/apigateway/Untitled%202.png)

1.2 Create a Lambda function `roshan-rimal-hello-dynamic` that returns `{"Hello":*<dynamic-route-name>}*`

1.2.1 Create a source file `[hello-dynamic.py](http://hello.py)` with the following content

```bash
import json
def handler(event,context):
		response={"Hello":"Default"}
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    } 
```

1.2.2 Create zip deployment

```bash
zip package-dynamic.zip hello-dynamic.py
```

![Untitled](images/apigateway/Untitled%203.png)

1.2.3 Create lambda function

1.2.3.2 Create the lambda function and deploy the `zip` package

```bash
# use the same Role ARN used above
aws lambda create-function --function-name roshan-rimal-hello-dynamic \
--zip-file fileb://package-dynamic.zip --handler hello-dynamic.handler --runtime python3.9 \
--role arn:aws:iam::949263681218:role/roshan-rimal-hello-lambda-role
```

 

![Untitled](images/apigateway/Untitled%204.png)

1.3 Re-deploy the function after updating the code using

```bash
aws lambda update-function-code  --function-name roshan-rimal-hello-dynamic \
--zip-file fileb://package-dynamic.zip
```

View the functions in console

![Untitled](images/apigateway/Untitled%205.png)

## Q.4.

4.1 Create an API Gateway API of type HTTP and add Lambda Integration

![Untitled](images/apigateway/Untitled%206.png)

4.2 View the created API Gateway

![Untitled](images/apigateway/Untitled%207.png)

4.3 Configure `/` route for `roshan-rimal-hello` lambda function

Configuring route

![Untitled](images/apigateway/Untitled%208.png)

Adding Integration to the Route

![Untitled](images/apigateway/Untitled%209.png)

Check that the route is working

![Untitled](images/apigateway/Untitled%2010.png)

4.4 Configure `/*` route for `roshan-rimal-hello-dynamic` lambda function

Configuring Route

![Untitled](images/apigateway/Untitled%2011.png)

Adding Integration to the Route

![Untitled](images/apigateway/Untitled%2012.png)

Check that the route is working

![Untitled](images/apigateway/Untitled%2013.png)