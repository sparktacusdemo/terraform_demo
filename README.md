### purpose <br>
create a VPC in AWS, composed of 3 zones, to allow high availability for our EC2 instances and clusters we will create/launch in.
<br>we need to create:
1 vpc 
subnets public and private: in total, we will have 2x3 = 6 subnetworks, my range of ip adresses 
1 internet gateway, to allow my instances to communicate in the vpc and internet
1 NAT gateaway, to allow my instances to connect to the internet , or other AWS services, like S3
Route tables: 1 table per subnet, to map the network traffic, how it is directed
<br>

we can apply 2 options:<br>
- manual
- automated

<br>

as we have 3 zones in our vpc; in total we need to configure 1 vpc, 6 subnets,6 route tables, 3 NAT gateway, 1 internet gateway, it would be etter to use the automated method. Lets use Terraform, to create the whole infrastructure.<br>

### Tools

- Terraform application
- VS code IDE

### Terraform  set up

Visit this documentation [here](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform)

### Overview
We need to create 2 files:
- 1 file (let say 'main.tf') in which we will list all the aws resource we need: vpc, subnets, etc 
```example: create a VPC in aws
resource "aws_vpc" "myvpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.tags
  }
}
```
- 1 file where we will define all the Terraform variables, this will help us to automate the process, for example if we need to update the VPC, or create another VPC 

