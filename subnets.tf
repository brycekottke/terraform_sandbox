//Public subnet 1a
//Route Table associations located in networking.tf
resource "aws_subnet" "public-1" {
  depends_on = ["aws_vpc.main_vpc"]
  vpc_id = "${aws_vpc.main_vpc.id}"
  cidr_block = "${var.global["public-1_cidr"]}"
  availability_zone = "${var.global["public_subnet-1_az"]}"
  tags {
    Name   = "${var.global["public_subnet-1_name"]}"
    Owner    = "${var.global["owner"]}"
    Type   = "Public"
    AZ     = "${var.global["public_subnet-1_az"]}"
    Managed-By = "Terraform"
  }
}

//Private subnet 1a
//Route Table associations located in networking.tf
resource "aws_subnet" "private-1" {
  depends_on = ["aws_vpc.main_vpc"]
  vpc_id = "${aws_vpc.main_vpc.id}"
  cidr_block = "${var.global["private-1_cidr"]}"
  availability_zone = "${var.global["public_subnet-1_az"]}"
  tags {
    Name   = "${var.global["private_subnet-1_name"]}"
    Owner    = "${var.global["owner"]}"
    Type   = "Private"
    AZ     = "${var.global["private_subnet-1_az"]}"
    Managed-By = "Terraform"
  }
}

