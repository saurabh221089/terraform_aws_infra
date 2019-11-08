provider "aws" {
  #access_key = "ACCESS_KEY_HERE"
  #secret_key = "SECRET_KEY_HERE"
  region     = "${var.region}"
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "tf_vpc" {
  cidr_block            = "${var.vpc_cidr}"
  instance_tenancy      = "default"
  enable_dns_hostnames  = true

  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_subnet" "tf_public_subnet1" {
  vpc_id            = "${aws_vpc.tf_vpc.id}"
  cidr_block        = "${var.tf_public_subnet1_cidr}"
  availability_zone = "ap-south-1a"

  tags = {
    Name            = "tf_public_subnet1"
  }
}

resource "aws_subnet" "tf_public_subnet2" {
  vpc_id            = "${aws_vpc.tf_vpc.id}"
  cidr_block        = "${var.tf_public_subnet2_cidr}"
  availability_zone = "ap-south-1b"

  tags = {
    Name            = "tf_public_subnet2"
  }
}

resource "aws_route_table" "tf_public_route_tbl" {
  vpc_id            = "${aws_vpc.tf_vpc.id}"

  tags = {
    Name            = "tf_public_route_tbl"
  }
}

resource "aws_route_table_association" "tf_public_subnet1_assn" {
  route_table_id    = "${aws_route_table.tf_public_route_tbl.id}"
  subnet_id         = "${aws_subnet.tf_public_subnet1.id}"
}

resource "aws_route_table_association" "tf_public_subnet2_assn" {
  route_table_id    = "${aws_route_table.tf_public_route_tbl.id}"
  subnet_id         = "${aws_subnet.tf_public_subnet2.id}"
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id            = "${aws_vpc.tf_vpc.id}"

  tags = {
    Name            = "TF_IGW"
  }
}

resource "aws_route" "tf_public_route" {
  route_table_id          = "${aws_route_table.tf_public_route_tbl.id}"
  gateway_id              = "${aws_internet_gateway.tf_igw.id}"
  destination_cidr_block  = "0.0.0.0/0"
}