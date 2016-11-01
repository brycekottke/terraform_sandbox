variable "global" {
  type = "map"
  default = {
   region = "us-east-1"
   vpc_name = "my-sandbox"
   internet-gateway-1 = "my-sandbox-igw"
   public_subnet-1_az = "us-east-1a"
   private_subnet-1_az = "us-east-1a"
   public_subnet-1_name = "Public_subnet-1" 
   private_subnet-1_name = "Private_subnet-1"
   vpc_cidr = "10.0.0.0/16"
   public-1_cidr = "10.0.1.0/24"
   private-1_cidr = "10.0.2.0/24"
   owner = "OWNER"
   pem_key_name = "Greg2wTest"
   my_ip = "67.185.132.195/32"
   ubuntu_ami = "ami-e3c3b8f4"
   windows_ami = "ami-3f0c4628"
  }
}
