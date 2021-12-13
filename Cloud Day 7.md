# Cloud Day 7

### Tasks:

1. Build and Host a React app in S3 bucket with static hosting enabled.
2. Create a CloudFront Distribution for accessing the website and deploy certificates as well

### Resources Used:

Region: `us-east-1a`

Bucket Name: `roshan-rimal-static-cloudfront-site` 

Bucket ARN: `arn:aws:s3:::roshan-rimal-static-cloudfront-site` 

CloudFront Distribution ARM : `arn:aws:cloudfront::949263681218:distribution/E26JV4JLO3RAKA`

### Q.1.

1.1  Create a Hello World React app

```bash
npx create-react-app react-assignment
cd react-assigment
npm start
```

1.2 Build the react app 

```bash
npm run build
```

View the build Artifacts 

![Untitled](images/Untitled.png)

2.1 Create a S3 bucket

```bash
aws s3api create-bucket --bucket rroshan-rimal-static-cloudfront-site \
                     --region us-east-1
```

![Untitled](images/Untitled%201.png)

2.2 Turn off the Block Public Access 

```bash
aws s3api put-public-access-block \
    --bucket roshan-rimal-static-cloudfront-site \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

![Untitled](images/Untitled%202.png)

Verify in the console

![Untitled](images/Untitled%203.png)

2.3 Upload the build Artifacts to the bucket

```bash
aws s3 sync ./ s3://roshan-rimal-static-cloudfront-site
```

![Untitled](images/Untitled%204.png)

Verify in the console

![Untitled](images/Untitled%205.png)

2.4 Enable static hosting and configure website settings for the bucket

```bash
aws s3 website s3://roshan-rimal-static-cloudfront-site --index-document index.html --error-document error.html
```

![Untitled](images/Untitled%206.png)

Verify in the console

![Untitled](images/Untitled%207.png)

 

## Q.2.

1. Create a cloudfront distribution and set S3 as origin

![Untitled](images/Untitled%208.png)

1. View the Created distribution

![Untitled](images/Untitled%209.png)

1. Access the website through the distribution 
    
    
    ![Untitled](images/Untitled%2010.png)
    

1. Restrict public access to have minimum permissions

```bash
aws s3api put-public-access-block \
    --bucket roshan-rimal-static-cloudfront-site \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=false"
```

![Untitled](images/Untitled%2011.png)

**This makes the S3 website only accessible through Cloudfront Origin Access Identity and no one can modify the permissions nor can access the S3 objects publicly.**

Verify the permissions in Console

![Untitled](images/Untitled%2012.png)

View the Policy in Console

![Untitled](images/Untitled%2013.png)