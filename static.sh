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
