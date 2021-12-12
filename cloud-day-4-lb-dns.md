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
    
  
## Add R53 entry to map above created ALB at URL **alb.<team-name>.<your-domain>**

Create route53 hosted zone

![Untitled](cloud-day-4-lb-dns%20c6455ea4515d47d9ae4f0947f802da30/Untitled%2018.png)

- Update the Nameservers to be Route 53 Nameservers

![Untitled](cloud-day-4-lb-dns%20c6455ea4515d47d9ae4f0947f802da30/Untitled%2019.png)

- Verify that the changes has been propagated

![Untitled](cloud-day-4-lb-dns%20c6455ea4515d47d9ae4f0947f802da30/Untitled%2020.png)

Completely Propagated

![Untitled](cloud-day-4-lb-dns%20c6455ea4515d47d9ae4f0947f802da30/Untitled%2021.png)

- Create `team-5` subdomain for the above domain

- Create ACM for above created R53 HZ with both top subdomain and its wild card ie **<team-name>.<your-domain>** and ***.<team-name>.<your-domain>**
- Update ALB
    - Accept request only when **Host = alb.<team-name>.<your-domain>**, with default action response Code: 503, Message: “Unknown Request” on both HTTP and HTTPS requests.
    - Enable HTTPS support.
    - Redirect HTTP to HTTPS.
    
- (Optional) Create Private Route53 with domain **<team-name>.vpc-local** and attach it to your VPC with DNS resolve enable.
    - Add A Record to map Private EC2’s Private IP to **ec2.<team-name>.vpc-local**.
    - Run telnet **ec2.<team-name>.vpc-local** 22, from public EC2 and verify it gets connected.
