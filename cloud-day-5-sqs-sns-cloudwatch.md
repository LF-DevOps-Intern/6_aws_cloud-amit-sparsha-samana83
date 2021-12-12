
# Cloud-Day-5-SQS-SNS-Cloudwatch

- Validate your email address in SES.

First Create an identity

![Untitled](images/Untitled.png)

Verify the email

![Untitled](images/Untitled%201.png)

View Verified identities

![Untitled](images/Untitled%202.png)

- Create SNS topic.
    
    
    ![Untitled](images/Untitled%203.png)
    
    View the created topic
    
    ![Untitled](images/Untitled%204.png)
    
    - Add subscription as Protocol Email, and endpoint your Email Address.
    
    ![Untitled](images/Untitled%205.png)
    
    Verify the subscription
    
    ![Untitled](images/Untitled%206.png)
    
    View the Subscription
    
    ![Untitled](images/Untitled%207.png)
    

- Create Event Bridge rule to monitor EC2 state change events. Set above created SNS topic as target.

![Untitled](images/Untitled%208.png)

Set SNS Topic as the target

![Untitled](images/Untitled%209.png)

- Verify the setup

Stop the instance

![Untitled](images/Untitled%2010.png)

View the email

![Untitled](images/Untitled%2011.png)

- (Optional)
    - Create standard SQS.
    
    ![Untitled](images/Untitled%2012.png)
    
    - Add this SQS as target in above created Event Bridge rule (in addition to existing SNS)
    
     
    
    ![Untitled](images/Untitled%2013.png)
    
    - Add lambda trigger in SQS to `sendEmail` lambda function.
    
    Create a lambda function named `team-5-sendEmail`
    
    ![Untitled](images/Untitled%2014.png)
    
    Allow `ReceiveMessage` on SQS in the function's role
    
    ![Untitled](images/Untitled%2015.png)
    
    Set Lambda Trigger for SQS queue
    
    ![Untitled](images/Untitled%2016.png)
    

     Lambda is set to be triggered when message arrives in the queue

![Untitled](images/Untitled%2017.png)

Update the Lambda Function's Role to have SES `sendEmail` permission

![Untitled](images/Untitled%2018.png)

![Untitled](images/Untitled%2019.png)

Attach the Policy to the Role

![Untitled](images/Untitled%2020.png)

**We have added another policy `team-5-ses-lambda-policy-v2` as well since we didn't have permission to edit the policy. This policy added the `sendEmail` permission for the recipient's address as well.**

**We have created a DLQ as well for avoiding continuous lambda invocation**

![Untitled](images/Untitled%2021.png)

Update the Lambda function with the following code

The code is commented wherever necessary for explanation

```bash
import json
import boto3
from botocore.exceptions import ClientError
import json
import ast

def lambda_handler(event, context):

      
    # AWS Region we using for Amazon SES.
    AWS_REGION = "us-east-1" 
    
    # create a ses client in the region us-east-1
    client = boto3.client('ses',region_name=AWS_REGION)
    
    # sender email address
    SENDER = "team5lftassignment@gmail.com"
    
    # Receiver email address
    RECIPIENT = "roshanlftassignment@gmail.com"
    
    # The subject line for the email.
    SUBJECT = "Team 5 Public EC2 instance stopped"
    
    
    # extracting the cloudwatch event body which is in text and converting
    # it into python object

    body=ast.literal_eval(event['Records'][0]['body'])
    print("body is",body)
    

    # Extracting the EC2, SQS specific information and time from the event that is passed to us.
    ec2_event={}
    ec2_event['eventsourcearn']=event['Records'][0]['eventSourceARN']
    ec2_event['awsregion']=event['Records'][0]['awsRegion']
    ec2_event['time']=body['time']
    ec2_event['detail_type']=body['detail-type']
    ec2_event['region']=body['region']
    ec2_event['instanceid']=body['detail']['instance-id']
    ec2_event['state']=body['detail']['state']
       
    
    # The HTML body of the email.
    BODY_HTML = """
    <html>
    <head>Alert! EC2 instace Stopped</head>
    <body>
    <h4>Details:</h4>
    SQS Region:   {awsregion}
    <br>
    Queue ARN:   {eventsourcearn}
    <br>
    <br>
    <h4>EC2 instance:</h4>
    <br>
    Region:   {region} <br>
    Instance ID: {instanceid} <br>
    State: {state} <br>
    Time: {time}
    
    DetailTup: {detail_type}
    
    
    
    </body>
    </html>
    
    """.format(**ec2_event)         
    
    # The character encoding for the email.
    CHARSET = "UTF-8"
    
    
    # Try to send the email.
    try:
        #Provide the contents of the email.
        response = client.send_email(
            Destination={'ToAddresses': [RECIPIENT]},
            Message={
                'Body': {
                    'Html': {
                        'Charset': CHARSET,
                        'Data': BODY_HTML,
                    }},
                'Subject': {
                    'Charset': CHARSET,
                    'Data': SUBJECT,
                },
            },
            Source=SENDER)
        
    # Display an error if something goes wrong.	
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        print("Email sent! Message ID:"),
        print(response['MessageId'])

```

View the Email

![Untitled](images/Untitled%2022.png)

Verify the Sender and Receiver

![Untitled](images/Untitled%2023.png)

View the mail

![Untitled](images/Untitled%2024.png)
