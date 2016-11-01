//OpenVPN Server
resource "aws_instance" "OpenVPN" {
  depends_on        = ["aws_subnet.public-1", "aws_security_group.owner_inbound"]
  ami             = "${var.global["ubuntu_ami"]}"
  instance_type     = "t2.micro"
  availability_zone     = "${var.global["public_subnet-1_az"]}"
  disable_api_termination = false
  key_name        = "${var.global["pem_key_name"]}"
  subnet_id       = "${aws_subnet.public-1.id}"
  security_groups     = [
              "${aws_security_group.owner_inbound.id}",
              "${aws_security_group.internet_sg.id}",
              "${aws_security_group.openvpn_sg.id}"
              ]

  user_data       = "${file("openvpn_userdata.sh")}"
    tags {
      Name  = "${var.global["owner"]}-OpenVPN"
      Owner   = "${var.global["owner"]}"
      Type  = "VPN"
      VPN = "Primary"
      Managed-By = "Terraform"
    }
}

//Private Ubuntu Server
resource "aws_instance" "ubuntu-1" {
  depends_on        = ["aws_subnet.private-1", "aws_security_group.owner_inbound"]
  ami             = "${var.global["ubuntu_ami"]}"
  instance_type     = "t2.micro"
  availability_zone     = "${var.global["private_subnet-1_az"]}"
  disable_api_termination = false
  key_name        = "${var.global["pem_key_name"]}"
  subnet_id       = "${aws_subnet.private-1.id}"
  security_groups     = [
              "${aws_security_group.internet_sg.id}",
              "${aws_security_group.vpc_inbound.id}"
            ]

    tags {
      Name  = "${var.global["owner"]}-Ubuntu-1"
      Owner   = "${var.global["owner"]}"
      Type  = "Ubuntu"
      Managed-By = "Terraform"

    }
}


//Windows Server
resource "aws_instance" "windows1" {
  depends_on        = ["aws_subnet.private-1", "aws_security_group.owner_inbound"]
  ami             = "${var.global["windows_ami"]}"
  instance_type     = "t2.micro"
  availability_zone     = "${var.global["private_subnet-1_az"]}"
  disable_api_termination = false
  key_name        = "${var.global["pem_key_name"]}"
  subnet_id       = "${aws_subnet.private-1.id}"
  security_groups     = [
              "${aws_security_group.internet_sg.id}",
              "${aws_security_group.vpc_inbound.id}"  
            ]

    tags {
      Name  = "${var.global["owner"]}-Windows-1"
      Owner   = "${var.global["owner"]}"
      Type  = "Windows"
      Managed-By = "Terraform"
    }
}
