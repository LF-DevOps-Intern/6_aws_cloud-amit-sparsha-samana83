# cloud-day-4-lb-dns

- Create Application Load balancer
    - Start a simple server in private EC2 8880
    - Target ALB to serve that server
    - ALB should be accessible through port 80 listener
    - Health Check
        - Register healthy on 3 success
        - Register unhealthy on 5 success
        - Timeout 5 Seconds
        - Interval 45 Seconds
    - Access the server via ALB publicly using ALB’s DNS name.
- Create Route53 Hosted Zone
    - Either use your own Domain if you have as **<team-name>.<your-domain>** **OR** use mine ie [intern.amitj.com.np](https://console.aws.amazon.com/route53/v2/hostedzones#ListRecordSets/Z051165739T629IMV4ELJ) to create new HZ for your use in pattern **<team-name>.intern.amitj.com.np**.
    - Show nslookup result for your domain.
    - Add R53 entry to map above created ALB at URL **alb.<team-name>.<your-domain>**
- Create ACM for above created R53 HZ with both top subdomain and its wild card ie **<team-name>.<your-domain>** and ***.<team-name>.<your-domain>**
- Update ALB
    - Accept request only when **Host = alb.<team-name>.<your-domain>**, with default action response Code: 503, Message: “Unknown Request” on both HTTP and HTTPS requests.
    - Enable HTTPS support.
    - Redirect HTTP to HTTPS.
- (Optional) Create Private Route53 with domain **<team-name>.vpc-local** and attach it to your VPC with DNS resolve enable.
    - Add A Record to map Private EC2’s Private IP to **ec2.<team-name>.vpc-local**.

Run telnet

**ec2.<team-name>.vpc-local**

22, from public EC2 and verify it gets connected.

First We create an application load balancer as follows:

![Untitled](images/Untitled.png)

We give a name for our load balancer and make it internet facing.

![Untitled](images/Untitled%201.png)

We set the VPC as team5's VPC and subnets as our public subnets

![Untitled](images/Untitled%202.png)

we add a listener at port 80

![Untitled](images/Untitled%203.png)

After adding a listener at port 80 we edit our security group to allow incoming traffic at port 80

![Untitled](images/Untitled%204.png)

Now we create a target group for our ALB where the ALB routes requests to the targets in a target group.

For this, we choose the target type as instances

![Untitled](images/Untitled%205.png)

We set the target group name, port,VPC and protocol version as follows:

![Untitled](images/Untitled%206.png)

We specify the port the load balancer uses when performing health checks on targets as 8880.

![Untitled](images/Untitled%207.png)

we set the parameters for health check as per our requirement as follows:

![Untitled](images/Untitled%208.png)

we then register a target for the target group created above(where our target is our private ec2 instance)

![Untitled](images/Untitled%209.png)

reviewing targets:

![Untitled](images/Untitled%2010.png)

Our created target group:

![Untitled](images/Untitled%2011.png)

Our created target:

![Untitled](images/Untitled%2012.png)

After setting up the target group and target our load balancer's configuration was found as follows:

The DNS name of our ALB is: [http://team-5-alb-1702691530.us-east-1.elb.amazonaws.com/](http://team-5-alb-1702691530.us-east-1.elb.amazonaws.com/)

![Untitled](images/Untitled%2013.png)

We can see that the load balancer has a listener at port 80 which forwards the requests to the target group we created.

![Untitled](images/Untitled%2014.png)

Now in our private ec2 instance, we create a simple index.html file 

![Untitled](images/Untitled%2015.png)

Then, we serve the file at port 8880 using python3 as follows: 

![Untitled](images/Untitled%2016.png)

we can access the created server using our created load balancer's DNS name(i.e. [http://team-5-alb-1702691530.us-east-1.elb.amazonaws.com/](http://team-5-alb-1702691530.us-east-1.elb.amazonaws.com/))

![Untitled](images/Untitled%2017.png)

## will do these two after ALB part is complete
Show nslookup result for your domain.

## Add R53 entry to map above created ALB at URL **alb.<team-name>.<your-domain>**

Create route53 hosted zone

![Untitled](images/Untitled%2018.png)

- Update the Nameservers to be Route 53 Nameservers

![Untitled](images/Untitled%2019.png)

- Verify that the changes has been propagated

![Untitled](images/Untitled%2020.png)

Completely Propagated

![Untitled](images/Untitled%2021.png)

- Create `team-5` subdomain for the above domain

![https://i.imgur.com/3V740mr.png](https://i.imgur.com/3V740mr.png)

![https://i.imgur.com/pyosKaQ.png](https://i.imgur.com/pyosKaQ.png)

- Create ACM for above created R53 HZ with both top subdomain and its wild card ie **<team-name>.<your-domain>** and ***.<team-name>.<your-domain>**

![https://i.imgur.com/8lmOPD5.png](https://i.imgur.com/8lmOPD5.png)

- Update ALB
    - Accept request only when **Host = alb.<team-name>.<your-domain>**, with default action response Code: 503, Message: “Unknown Request” on both HTTP and HTTPS requests.
    - Enable HTTPS support.
    - Redirect HTTP to HTTPS.
    
- (Optional) Create Private Route53 zone with domain **<team-name>.vpc-local** and attach it to your VPC with DNS resolve enable.
    - Add A Record to map Private EC2’s Private IP to **ec2.<team-name>.vpc-local**.
    - Run telnet **ec2.<team-name>.vpc-local** 22, from public EC2 and verify it gets connected.
