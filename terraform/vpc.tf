# Create a new Virtual Private Cloud (VPC) for the AWS ECS cluster
# This VPC will be used by the Load Balancers and Target Groups.


# Define the VPC
resource "aws_vpc" "cluster_vpc" {
    cidr_block  = var.cluster_config.vpc.network_cidr
    tags        = {
        name    = var.cluster_config.vpc.name
    }
}

# Define the internet gateway for the public subnet
resource "aws_internet_gateway" "cluster_vpc_gateway" {
    vpc_id      = aws_vpc.cluster_vpc.id
    tags        = {
        name    = "${var.cluster_config.vpc.name} gateway"
    }
}

# Get the list of availability zones of the VPC  based on the ECS cluster region
data "aws_availability_zones" "available_zones" {}

# Define the first public subnet for the VPC
resource "aws_subnet" "public_subnet_01" {
    vpc_id                  = aws_vpc.cluster_vpc.id
    cidr_block              = var.cluster_config.vpc.public_01_cidr
    availability_zone       = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = true
    tags                    = {
        name                = "${var.cluster_config.vpc.name} public_subnet_01"
    }
}

# Define the second public subnet for the VPC
resource "aws_subnet" "public_subnet_02" {
    vpc_id                  = aws_vpc.cluster_vpc.id
    cidr_block              = var.cluster_config.vpc.public_02_cidr
    availability_zone       = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = true
    tags                    = {
        name                = "${var.cluster_config.vpc.name} public_subnet_02"
    }
}

# Define the third public subnet for the VPC
resource "aws_subnet" "public_subnet_03" {
    vpc_id                  = aws_vpc.cluster_vpc.id
    cidr_block              = var.cluster_config.vpc.public_03_cidr
    availability_zone       = data.aws_availability_zones.available_zones.names[2]
    map_public_ip_on_launch = true
    tags                    = {
        name                = "${var.cluster_config.vpc.name} public_subnet_03"
    }
}

# Define the routing table for public_subnet_01
resource "aws_route_table" "subnet_route_table" {
    vpc_id                  = aws_vpc.cluster_vpc.id
    route                   {
        cidr_block          = var.cluster_config.vpc.route_cidr
        gateway_id          = aws_internet_gateway.cluster_vpc_gateway.id
    }
    tags                    = {
        name                = "${var.cluster_config.vpc.name} subnet_route_table"
    }
}

# Associate routing table subnet_route_table to subnet public_subnet_01
resource "aws_route_table_association" "assoc_subnet_01_with_route_table" {
    subnet_id       = aws_subnet.public_subnet_01.id
    route_table_id  = aws_route_table.subnet_route_table.id
}

# Associate routing table subnet_route_table to subnet public_subnet_02
resource "aws_route_table_association" "assoc_subnet_02_with_route_table" {
    subnet_id       = aws_subnet.public_subnet_02.id
    route_table_id  = aws_route_table.subnet_route_table.id
}

# Associate routing table subnet_route_table to subnet public_subnet_03
resource "aws_route_table_association" "assoc_subnet_03_with_route_table" {
    subnet_id       = aws_subnet.public_subnet_03.id
    route_table_id  = aws_route_table.subnet_route_table.id
}