#!/bin/bash

cd ~/demoreact

# build the static react application
npm run build

cd ~/demoreact/build

# Update the bucket with new build artifacts
aws s3 sync ./ s3://samana-reactapp-bucket


