# Cloud-Day-3-VPC-Peering

### Requirements:

Region: `us-east-1` (because we are team number 5)

VPC CIDR: `10.15.40.0/22`

Tags: 

Team-Name: `intern-e`

Member1: `Bigyan Koirala`

Member2: `Roshan Rimal`

Member3: `Samana Pokhrel`

Name: `team-5-<resource-name>`

View the Route Tables

![Untitled](images/Untitled%203.png)

View Route Table

![Untitled](images/Untitled%204.png)

View Route Table

![Untitled](images/Untitled%205.png)

- Verify that the peering works by trying to pinging `team-1`'s instance from our instance

Get the address for the instance

![Untitled](images/Untitled%206.png)

Allow ICMP traffic from our VPC in the `team-1`'s instance

![Untitled](images/Untitled%207.png)

Ping `team-1`'s private instance from our private instance

![Untitled](images/Untitled%208.png)

Also trying with public route table as well:

Ping `team-1`'s private instance from our public instance

![Untitled](images/Untitled%209.png)

    
    Finally we can connect to this database from our private instance with following command
    
    ```bash
    psql --host=team-5-rds.codlcyqbqlbt.us-east-1.rds.amazonaws.com \
         --port=5432 --username=team5 --password --dbname=postgres
    ```
    
    ![Untitled](images/Untitled%2011.png)
    
    (Optional) Connecting to the RDS instance of another team (`team-1`)
    
    Edit `team-1`'s SG to allow `postgres` traffic from our VPC
    
    ![Untitled](images/Untitled%2012.png)
    
    Similarly, we can connect to `team-1`'s database from our private instance with following command
    
    ```bash
    psql --host=intern-a-rds.codlcyqbqlbt.us-east-1.rds.amazonaws.com \
         --port=5432 --username=postgres --password --dbname=postgres
    ```
    
    ![Untitled](images/Untitled%2013.png)
    
2. Install AWS CLIv2 and config lft-training profile.

Install AWS CLIv2

```bash
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

![Untitled](images/Untitled%2014.png)

Update the `~/.aws/credentials` file with Access Key ID and Secret Access Key as follows:

![Untitled](images/Untitled%2015.png)

Use the `lft-training` for the current bash session

```bash
export AWS_PROFILE=lft-training  #to use the lft profile for the current bash session
```

Test access to aws

```docker
aws s3 ls
```

![Untitled](images/Untitled%2016.png)

1. Create ECR and upload your Docker image created during Docker assignment Q3. Each member must upload an image (in team’s ECR repo) with their name as tag.
    
    
    Create a private repository in ECR
    
    ![Untitled](images/Untitled%2017.png)
    
    Pull exisiting images from `dockerhub`
    
    ```docker
    docker pull rimalroshan/nodeapi-lft
    docker pull rimalroshan/react-lft
    docker pull rimalroshan/nginx-lft
    docker images
    ```
    
    ![Untitled](images/Untitled%2018.png)
    
    Authenticate with ECR docker registry
    
    ```bash
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 949263681218.dkr.ecr.us-east-1.amazonaws.com
    ```
    
    ![Untitled](images/Untitled%2019.png)
    
    Tag and push the images to the registry
    
    ```bash
    #push react-lft image
    docker tag rimalroshan/react-lft 949263681218.dkr.ecr.us-east-1.amazonaws.com/team-5-private-repo:roshan_rimal_react
    docker push 949263681218.dkr.ecr.us-east-1.amazonaws.com/team-5-private-repo:roshan_rimal_react
    
    #push nodeapi image
    docker tag rimalroshan/nodeapi-lft 949263681218.dkr.ecr.us-east-1.amazonaws.com/team-5-private-repo:roshan_rimal_nodeapi
    docker push 949263681218.dkr.ecr.us-east-1.amazonaws.com/team-5-private-repo:roshan_rimal_nodeapi
    
    ```
    
    ![Untitled](images/Untitled%2020.png)
    
    ![Untitled](images/Untitled%2021.png)
    
    View the images in ECR private repository
    
    ![Untitled](images/Untitled%2022.png)
    
2. Deploy **one*** of uploaded image in ECS Fargate.
    - Create task definition.
    - Deploy in Public Subnet.
    - Access via assigned Public IP and your port.
    
    **Create a Cluster**
    
    ![Untitled](images/Untitled%2023.png)
    
    **Select Cluster template that can be used with Fargate**
    
    ![Untitled](images/Untitled%2024.png)
    
    **Configure Cluster**
    
    ![Untitled](images/Untitled%2025.png)
    
    **Create a task definition and select launch type to be fargate**
    
    ![Untitled](images/Untitled%2026.png)
    
    **Configure Container**
    
    ![Untitled](images/Untitled%2027.png)
    
    **Configure container ports**
    
    ![Untitled](images/Untitled%2028.png)
    
    **View Task Definition**
    
    ![Untitled](images/Untitled%2029.png)
    
    **Create Service**
    
    ![Untitled](images/Untitled%2030.png)
    
    **Launch the cluster in public subnet of your VPC**
    
    ![Untitled](images/Untitled%2031.png)
    
    **Configure security group to allow traffic to the service being deployed**
    
    ![Untitled](images/Untitled%2032.png)
    
    **View Service**
    
    ![Untitled](images/Untitled%2033.png)
    
    **View Tasks**
    
    ![Untitled](images/Untitled%2034.png)
    
    **Access the APIs through public IP**
    
    **API 1**
    
    ![Untitled](images/Untitled%2035.png)
    
    **API 2**
    
    ![Untitled](images/Untitled%2036.png)
    
3. Create a S3 bucket and Upload Dockerfile of Q4 in the bucket using AWS CLI.

Create a s3 bucket

```bash
aws s3api create-bucket --bucket team-5-s3-dockerfile-bucket \
                     --region us-east-1
```

![Untitled](images/Untitled%2037.png)

Tag the bucket appropriately

```bash
aws s3api put-bucket-tagging --bucket team-5-s3-dockerfile-bucket \
 --tagging '
							TagSet=[
							{Key=Team-Name,Value=intern-e},
							{Key=Member1,Value="Bigyan Koirala"},
							{Key=Member2,Value="Roshan Rimal"},
							{Key=Member3,Value="Samana Pokhrel"}]'
```

![Untitled](images/Untitled%2038.png)

View the bucket

![Untitled](images/Untitled%2039.png)

Upload the `Dockerfile`

```bash
aws s3api put-object --bucket team-5-s3-dockerfile-bucket \
		--key Dockerfile_roshan_react \
		--body /home/rimalroshan/cloud-day3/Dockerfile_react

aws s3api put-object --bucket team-5-s3-dockerfile-bucket  \
		--key Dockerfile_roshan_node \
     --body /home/rimalroshan/cloud-day3/Dockerfile_nodeapi
```

![Untitled](images/Untitled%2040.png)

View the `Dockerfile` in `s3`

![Untitled](images/Untitled%2041.png)

If you need to delete a object then you can use the `s3api` `delete-object` command

```bash
aws s3api delete-object --bucket team-5-s3-dockerfile-bucket  --key Dockerfile_react
```

![Untitled](images/Untitled%2042.png)