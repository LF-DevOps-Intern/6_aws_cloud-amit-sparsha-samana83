**All task are in continuation of yesterday’s setup. Use same VPC and tag convention for all resources.**

- (Optional) Enable VPC Flow Logs via CloudWatch Log.

![https://i.imgur.com/xW4fWKN.png](https://i.imgur.com/xW4fWKN.png)

- Create 3 subnets in each AZ to be used as public.

  ![https://i.imgur.com/reUgda1.png](https://i.imgur.com/reUgda1.png)

- Create 3 subnets in each AZ to be used as private.

![https://i.imgur.com/ndFQgV8.png](https://i.imgur.com/ndFQgV8.png)

- Create Public Route Table and associate public subnets.

![https://i.imgur.com/9cnwOvV.png](https://i.imgur.com/9cnwOvV.png)

- Create Private Route Table and associate private subnets.

![https://i.imgur.com/ECIDUTF.png](https://i.imgur.com/ECIDUTF.png)

- Create Internet Gateway and attach its route in public route table.

![https://i.imgur.com/kgcT4GO.png](https://i.imgur.com/kgcT4GO.png)

![https://i.imgur.com/MsDu7iH.png](https://i.imgur.com/MsDu7iH.png)

attach Internet Gateway to public route table

![https://i.imgur.com/zPtGQc7.png](https://i.imgur.com/zPtGQc7.png)

![https://i.imgur.com/05faSDZ.png](https://i.imgur.com/05faSDZ.png)

- Create NAT (and EIP for it) and attach its route in private route table.

![https://i.imgur.com/TX1IQQG.png](https://i.imgur.com/TX1IQQG.png)

![https://i.imgur.com/hvbHt8J.png](https://i.imgur.com/hvbHt8J.png)

![https://i.imgur.com/dHxRlTj.png](https://i.imgur.com/dHxRlTj.png)
