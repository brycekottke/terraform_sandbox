//Inbound All My IP
resource "aws_security_group" "owner_inbound" {
  name    = "${var.global["owner"]}_inbound"
  description = "Allow all traffic from ${var.global["owner"]} home IP"
  vpc_id    = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${var.global["my_ip"]}"]
  }
}

//Inbound from the internet
resource "aws_security_group" "internet_sg" {
  name    = "http & https inbound - Terraform"
  description = "Allow inbound internet traffic. Managed by Terraform"
  vpc_id    = "${aws_vpc.main_vpc.id}"

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

      ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

//OpenVPN Security Group
resource "aws_security_group" "openvpn_sg" {
  name        = "openvpn-sg - Terraform"
  description = "Inbound rules for OpenVPN. Managed by Terraform"
  vpc_id      = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//Allow Inbound From VPC
resource "aws_security_group" "vpc_inbound" {
  name  = "${var.global["vpc_name"]}_Inbound - Terraform"
  description = "Allows inbound traffic from VPC. Managed by Terraform"
  vpc_id  = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["${var.global["vpc_cidr"]}"]
  }
}
