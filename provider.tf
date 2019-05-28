#Provides a VPC resource

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "190.160.0.0/16"
  insstance_tenancy = "default"

  tags {
      Name = "main"
      Location = "Kiev"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "190.160.1.0/24"

  tags {
      Name = "Subnet1"
  }
}




