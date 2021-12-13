# Cloud Day 7

### Tasks:

1. Build and Host a React app in S3 bucket with static hosting enabled.
2. Create a CloudFront Distribution for accessing the website and deploy certificates as well

### Resources Used:

Region: `us-east-1a`

Bucket Name: `roshan-rimal-static-cloudfront-site` 

Bucket ARN: `arn:aws:s3:::roshan-rimal-static-cloudfront-site` 

CloudFront Distribution ARM : `arn:aws:cloudfront::949263681218:distribution/E26JV4JLO3RAKA`

CloudFront Distribution URL: `[roshan.lftassignment.tk](http://roshan.lftassignment.tk)`

Route 53 Hosted Zone Name: `lftassignment.tk`

ACM Certificate ARN: `arn:aws:acm:us-east-1:949263681218:certificate/d4984a2a-2306-4f75-aba1-710bd0b38b6b` 

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

1.3 Create a S3 bucket

```bash
aws s3api create-bucket --bucket rroshan-rimal-static-cloudfront-site \
                     --region us-east-1
```

![Untitled](images/Untitled%201.png)

1.4 Turn off the Block Public Access 

```bash
aws s3api put-public-access-block \
    --bucket roshan-rimal-static-cloudfront-site \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

![Untitled](images/Untitled%202.png)

Verify in the console

![Untitled](images/Untitled%203.png)

1.5 Upload the build Artifacts to the bucket

```bash
aws s3 sync ./ s3://roshan-rimal-static-cloudfront-site
```

![Untitled](images/Untitled%204.png)

Verify in the console

![Untitled](images/Untitled%205.png)

1.6 Enable static hosting and configure website settings for the bucket

```bash
aws s3 website s3://roshan-rimal-static-cloudfront-site --index-document index.html --error-document error.html
```

![Untitled](images/Untitled%206.png)

Verify in the console

![Untitled](images/Untitled%207.png)

 

## Q.2.

2.1 Create a cloudfront distribution and set S3 as origin

![Untitled](images/Untitled%208.png)

2.2 View the Created distribution

![Untitled](images/Untitled%209.png)

2.3 Access the website through the distribution 

![Untitled](images/Untitled%2010.png)

2.4 Created a custom domain [`lftassignment.tk`](http://lftassignment.tk/) and assign ACM certificate for the same domain

2.4.1 Requesting a public certificate for the domain and all of its sub-domain

![Untitled](images/Untitled%2011.png)

 

2.4.2 Inserting the `CNAME` record for verifying domain ownership

![Untitled](images/Untitled%2012.png)

2.4.3 Verifying that the certificate is issued

![Untitled](images/Untitled%2013.png)

2.4.4 Edit the Cloudfront distribution to use the custom domain and provide above certificate to it

![Untitled](images/Untitled%2014.png)

2.4.5 Insert Alias Record in Route53 for the custom domain and point it to Cloudfront distribution

![Untitled](images/Untitled%2015.png)

2.4.6 Access the cloudfront distribution using custom domain name

![Untitled](images/Untitled%2016.png)

2.4.7 View the certificates for the site

![Untitled](images/Untitled%2017.png)

2.5 Restrict public access to have minimum permissions

```bash
aws s3api put-public-access-block \
    --bucket roshan-rimal-static-cloudfront-site \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=false"
```

![Untitled](images/Untitled%2018.png)

**This makes the S3 website only accessible through Cloudfront Origin Access Identity and no one can modify the permissions nor can access the S3 objects publicly.**

Verify the permissions in Console

![Untitled](images/Untitled%2019.png)

View the Policy in Console

![Untitled](images/Untitled%2020.png)