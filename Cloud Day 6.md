# Cloud Day 6

### Tasks:

1. Write a script that backs up an SQL dump and uploads it to an S3 Bucket. The contents of the S3 bucket should not be accessible via public.
2. Create a Lambda function that is triggered by an object being uploaded to an S3 bucket. If the object’s name starts with `make_public`, ensure that the object is publicly accessible.

### Resources Used:

Region: `us-east-1a`

Bucket Name: `roshan-rimal-db-backup`

Bucket ARN: `arn:aws:s3:::roshan-rimal-db-backup` 

Lambda Function Name: `roshan_rimal_s3_permission_update`

Lambda ARN: `arn:aws:lambda:us-east-1:949263681218:function:roshan_rimal_s3_permission_update`

### Task 1:

### Step 1: Create and Configure S3 bucket

Create the bucket

```bash
aws s3api create-bucket --bucket roshan-rimal-db-backup \
                     --region us-east-1
```

![Untitled](images/Untitled.png)

Configure Public Access Block settings to allow access through ACL. We will be modifying the backup object's ACL to allow public access in the lambda function.

```bash
aws s3api put-public-access-block \
    --bucket roshan-rimal-db-backup \
    --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

![Untitled](images/Untitled%201.png)

Verify that the bucket has been created

![Untitled](images/Untitled%202.png)

### Step 2: Write a script to take backup and upload it to s3 bucket

- Install and setup mysql version 8.x
    
    1. Install mysql version 8.x
    
    ```bash
    sudo apt update
    sudo apt install mysql-server
    ```
    
    2. Create a users, database
    
    ```bash
    #login as root user to create test users
    mysql -u root -p
    
    #create databases
    CREATE DATABASE clouddb;
    
    #create administration user
    CREATE USER 'adminuser'@'localhost' IDENTIFIED WITH mysql_native_password BY 'adminpw';
    
    #grant appropriate permission to administrator user
    GRANT ALL ON clouddb.* TO 'adminuser'@'localhost';
    ```
    

Create a `.my.cnf` file in your home directory to store the credentials for `mysqldump` with the following content:

```bash
[mysqldump]
user=adminuser
password=adminpw
```

Change its permissions using `chmod 600 .my.cnf`

Create a script named `backup.sh` with the following content. The script has been commented to explain the steps

```bash
#!/bin/bash

# if the backup folder does't exist create it
if [ ! -d ~/backup ]; then
  mkdir ~/backup
fi

#generating name for the backup file

#first file will be publicly accessible in S3
backup1=make_public_backup`date +%Y%m%d_%H%M%S`.db

#second file will be private and wont be accessible publicly in S3
backup2=private_backup`date +%Y%m%d_%H%M%S`.db

#take backup of the database
mysqldump -u adminuser clouddb > ~/backup/$backup1 --no-tablespaces
mysqldump -u adminuser clouddb > ~/backup/$backup2 --no-tablespaces

#Note that this wont work smoothly for large files, as you need to upload using
#multipart upload

bucket_name=roshan-rimal-db-backup

#upload the backup to s3
aws s3api put-object --bucket $bucket_name \
		--key $backup2 \
		--body /home/rimalroshan/backup/$backup1

aws s3api put-object --bucket $bucket_name \
		--key $backup2 \
		--body /home/rimalroshan/backup/$backup2
```

Change its permissions using `chmod 700 backup.sh`

Check that the script is working

![Untitled](images/Untitled%203.png)

### Step 3: Create a cron job for taking backup three times a day

Open the `crontab` file

```bash
crontab -e # -e for editing the cron table
```

Add the following rule to the `crontab` file

```bash
0 0,6,13 * * * ~/backup.sh
```

![Untitled](images/Untitled%204.png)

This rule executes the `backup.sh` the script everyday at 6:00 am, 1:00 pm and 12:00 am.

Verify that the rule has been added

```bash
crontab -l # list the crontab file
```

![Untitled](images/Untitled%205.png)

Verify that the rule is correct

![Untitled](images/Untitled%206.png)

### Step 4: Create Lambda function

Create a policy with `PutObjectAcl` permission for `S3` 

![Untitled](images/Untitled%207.png)

Create a Role and attach the above policy as well as `LambdaBasicExecution`Role policy

![Untitled](images/Untitled%208.png)

Verify that the required policy has been attached

![Untitled](images/Untitled%209.png)

Create a lambda function:

![Untitled](images/Untitled%2010.png)

Attach the role created previously to the lambda function:

![Untitled](images/Untitled%2011.png)

Add S3 Object Creation trigger for Lambda function

![Untitled](images/Untitled%2012.png)

We are triggered only when the prefix matches `make_public`

![Untitled](images/Untitled%2013.png)

Deploy the following code in the lambda function:

```bash
# This function ensures that if the object’s name starts with make_public,
# it is made publicly accessible.

import json
import boto3

def lambda_handler(event, context):

    # extracting the bucket name and object name from the event
    bucket_name=event['Records'][0]['s3']['bucket']['name']
    object_name=event['Records'][0]['s3']['object']['key']
    
    print("bucket name is", bucket_name)
    print("object name is", object_name)
    
    
    
    #initializing an s3 resourcce
    s3=boto3.resource('s3')
    
    #getting the uploaded public object
    public_object=s3.Object(bucket_name,object_name)
    
    #get the ACL object for the uploaded object
    acl=public_object.Acl()
    
    #make the object publicly accessible
    acl.put(ACL='public-read')

```

Check permissions of the object in `s3`

![Untitled](images/Untitled%2014.png)

Object with prefix `make_public` are made public

![Untitled](images/Untitled%2015.png)

Access denied for the private objects

![Untitled](images/Untitled%2016.png)

# Extra:

### CloudWatch Events → Execute Script Lambda → Execute Script on EC2 → backup upload S3 →  Modify Permissions Lambda