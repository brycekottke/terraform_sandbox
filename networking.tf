//Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "${var.global["vpc_cidr"]}"
  tags {
    Name = "${var.global["vpc_name"]}"
    Managed-By = "Terraform"
      }
}

//Internet Gateway
resource "aws_internet_gateway" "internet-gateway-1" {
  depends_on = ["aws_vpc.main_vpc"]
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags {
    Name = "${var.global["internet-gateway-1"]}"
    Managed-By = "Terraform"
  }
}

//NAT Gateway EIP
resource "aws_eip" "natgw-eip" {
  vpc = true
  }

//NAT Gateway
resource "aws_nat_gateway" "nat-gateway-1" {
  depends_on  = ["aws_vpc.main_vpc"]
  allocation_id = "${aws_eip.natgw-eip.id}"
  subnet_id = "${aws_subnet.private-1.id}"
}

//Public Subnet Route Table
resource "aws_route_table" "public-1" {
  vpc_id    = "${aws_vpc.main_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gateway-1.id}"
  }
}

//Private Subnet Route Table
resource "aws_route_table" "private-1" {
  vpc_id  = "${aws_vpc.main_vpc.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = "${aws_nat_gateway.nat-gateway-1.id}"
  }
}

//Public RTB Associate to Public Subnet 1
resource "aws_route_table_association" "public_route" {
  subnet_id     = "${aws_subnet.public-1.id}"
  route_table_id  = "${aws_route_table.public-1.id}"
}

//Private RTB Associate to Private Subnet 1
resource "aws_route_table_association" "private_route" {
  subnet_id = "${aws_subnet.private-1.id}"
  route_table_id  = "${aws_route_table.private-1.id}"
}

//OpenVPN EIP
resource "aws_eip" "OpenVPN-EIP" {
       vpc             = true
       instance        = "${aws_instance.OpenVPN.id}"
}

output "OpenVPN-IP" {
        value   = "${aws_eip.OpenVPN-EIP.public_ip}"
}

