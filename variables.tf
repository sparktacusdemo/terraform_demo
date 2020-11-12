#variables

# aws configuration
variable "awsregion" {
    description = "aws region"
    type = string
    default = "eu-west-3"
}
variable "awsaccesskey" {
    description = "aws access key"
    type = string
    default = "xxxxxxxxxxxxxxx"
}
variable "awssecretkey" {
    description = "aws secret key"
    type = string
    default = "xxxxxxxxxxxxxxxxxxx"
}

# aws vpc
variable "cidr_block" {
    description = "block for vpc"
    type =  string
    default = "10.0.0.0/16"
} 

variable "instance_tenancy" {
    description = "instance tenancy for vpc"
    type = string
    default = "default"
}

variable "tags" {
    description = "tag for vpc"
    type = string
    default = "my-vpc-3zones"
}

#############
#subnets
#############
variable "public_subnet_cidr_blocks" {
    default = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
    type = list
    description = "public subnets blocks"
}
variable "private_subnet_cidr_blocks" {
    default = ["10.0.100.0/24","10.0.101.0/24","10.0.102.0/24"]
    type = list
    description = "private subnets blocks"
}
variable "av_zones" {
    default = ["eu-west-3a","eu-west-3b","eu-west-3c"]
    type = list
    description = "availability zones"
}