### Purpose <br>
Here i would like to create a VPC in AWS, composed of 3 zones, to allow high availability for our EC2 instances and clusters we will create/launch in.
<br>we need to create:
1 vpc 
subnets public and private: in total, we will have 2x3 = 6 subnetworks, my range of ip adresses 
- 1 internet gateway, to allow my instances to communicate in the vpc and internet
- 1 NAT gateaway, to allow my instances to connect to the internet , or other AWS services, like S3
- 2 elastic IPs adresses for my NAT gateaway
- Route tables: 1 table per subnet, to map the network traffic, how it is directed
<br>

we can apply 2 options:<br>
- manual
- automated

<br>

as we have 3 zones in our vpc; in total we need to configure 1 vpc, 6 subnets,6 route tables, 3 NAT gateway, 1 internet gateway, it would be better/'smart' to use the automated method. Lets use Terraform, to create the whole infrastructure.<br>

### Tools

- Terraform application
- VS code IDE

### Terraform  set up

Visit this documentation [here](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform)

### Overview
We need to create 2 files:
- 1 file (let say 'main.tf') in which we will list all the aws resource we need: vpc, subnets, etc 
```
#example: create a aws vpc
resource "aws_vpc" "myvpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.tags
  }
}
```

```
#example: create a subnet
resource "aws_subnet" "public" {
  count             = length(var.av_zones)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.av_zones[count.index]
}
```
- 1 file where we will define all the Terraform variables, this will help us to automate the process, for example if we need to update the VPC, or create another VPC. If we want to add a new zone in the VPC, we just have to update the variables Terraform file. The same , if we ned to change the subnets block CIDR.

### Run Terraform
Once the Terraform .tf files are completed, run the application

```
# from your Terraform directory: run the commands below
#initialize terraform back end
$--1/ terraform init
#--2/ submit your plan
$ terraform plan
#--3/ apply your plan
$ terraform apply
```
voila !

<br>

If you want to test, clone my repository, run the Terraform application. And do not forget to delete the infrastructure, to avoid being billed by aws; just run the Terraform command:
```
$ terraform destroy
```


### Check
Go into you aws console and check the infrastructure, i used to check in the following order:
- vpc
- subnets
- route tables
- nat gateaway
- internet gateaway

<br>
that's it! my aws vpc infrastructure is built and active, i can now create my EC2 instances inside it ....
