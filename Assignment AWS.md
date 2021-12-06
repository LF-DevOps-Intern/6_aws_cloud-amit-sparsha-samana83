# Assignment AWS

### Requirements:

Region: `us-east-1` (because we are team number 5)

VPC CIDR: `10.15.40.0/22`

EC2 Instance:

AMI: `Amazon Linux 2`

Instance type: `t2.micro`

EBS Volume:

Type: `General`

Size: `10Gi`

Root Volume: `no` (should be detachable)

Tags:

Team-Name: `intern-5`

Member1: `Bigyan Koirala`

Member2: `Roshan Rimal`

Member3: `Samana Pokhrel`

Name: `team-5-<resource-name>`

### Architecture diagram for the assignment:

![1.svg](images/1.svg)

## Q.1.

1.1 Change region to `us-east-1`

![Untitled](images/Untitled.png)

1.2 Create VPC

We create a VPC with CIDR 10.15.{8\*team_number}.0/22

Since we are team number 6 the required CIDR is `10.15.40.0/22`

![Untitled](images/Untitled%201.png)

1.3 Assign Name and CIDR to VPC

![Untitled](images/Untitled%202.png)

1.4 Tag the Resource

![Untitled](images/Untitled%203.png)

## Q.2.

​

2.1 Lauch EC2 Instance

​

![Untitled](images/Untitled%204.png)

​

2.1.1 Select AMI as Amazon Linux 2

​

![Untitled](images/Untitled%205.png)

​

2.1.2 Choose Instance type as t2.micro

​

![Untitled](images/Untitled%206.png)

​

2.1.3 Select the VPC to be default VPC

​

![Untitled](images/Untitled%207.png)

​

2.1.4 Add General Purpose detachable EBS volume

​

![Untitled](images/Untitled%208.png)

​

2.1.5 Tag the EC2 instance, along with the Volume created above

​

![Untitled](images/Untitled%209.png)

​

2.1.6 Allow EC2 instance to be publicly accessible

​

Configure Security Group to allow SSH from everywhere

​

![Untitled](images/Untitled%2010.png)

​

2.1.7 Review and Launch the Instance

​

![Untitled](images/Untitled%2011.png)

​

2.1.8 Create `ssh` key-pair and download the private key to access the instance

​

Created keypair before launching the instance

​

![Untitled](images/Untitled%2012.png)

​

2.1.9 Change the private key permission and connect to the EC2 instance

​

```bash

chmod 400 team-5-keypair.pem

ssh -i "team-5-keypair.pem" ec2-user@ec2-54-163-188-228.compute-1.amazonaws.com

```

![Untitled](Untitled%204f9f5b64965a410e91e6db4c08aa4bb7/Untitled%209.png)

2.1.10 Update the repository

![Untitled](https://github.com/LF-DevOps-Intern/6_aws_cloud-amit-sparsha-samana83/blob/main/images/Untitled%2014.png)

![Untitled](https://github.com/LF-DevOps-Intern/6_aws_cloud-amit-sparsha-samana83/blob/main/images/Untitled%2015.png)

2.1.11 Setup EPEL repo

```docker
sudo amazon-linux-extras install epel
```

2.1.12 Install `openvpn` package:

```docker
sudo yum update
sudo yum install openvpn
```

![Untitled](https://github.com/LF-DevOps-Intern/6_aws_cloud-amit-sparsha-samana83/blob/main/images/Untitled%2016.png)

![Untitled](https://github.com/LF-DevOps-Intern/6_aws_cloud-amit-sparsha-samana83/blob/main/images/Untitled%2017.png)
