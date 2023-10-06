output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.tf_vpc.cidr_block
}

output "public_subnet_1_id" {
  value = aws_subnet.tf_public_subnet1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.tf_public_subnet2.id
}

