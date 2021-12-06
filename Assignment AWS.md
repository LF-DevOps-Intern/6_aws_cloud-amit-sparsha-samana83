
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

We create a VPC with CIDR 10.15.{8*team_number}.0/22 

Since we are team number 6 the required CIDR is `10.15.40.0/22`

![Untitled](images/Untitled%201.png)

1.3 Assign Name and CIDR to VPC

![Untitled](images/Untitled%202.png)

1.4 Tag the Resource

![Untitled](images/Untitled%203.png)
