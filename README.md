# terraform_sandbox
This will create a simple AWS environment that contains the following:
 - VPC
 - 1 Public Subnet, includes Internet Gateway
 - 1 Private Subnet, includes NAT Gateway
 - 1 Publicly accessible Ubuntu server
	~ Please note that there is a userdata script that bootstraps OpenVPN AS to the server. This requires some user configuration. 
	~ Please see the OpenVPN AS Documentation supplied by OpenVPN on how to configure - https://openvpn.net/index.php/access-server/docs/quick-start-guide.html
 - 1 internally accessible Ubuntu server
 - 1 privately accessible Windows server 

Please note the following:

If you are using this to create an environment outside of the North Virginia environment, you will need to update the following variables:
 - region
 - ubuntu_ami
 - windows_ami

You will need to update the following variables in the 'variables.tf' file:
 - pem_key_name
 - my_ip

I recommended that you change the following variables in order to keep your environment properly tagged/organized:
 - vpc_name
 - internet-gateway-1
 - owner

If you would like to add more to the environment, simply add your resources to their respected .tf configuratin files and run 'terraform plan' to verify that your deployment will be successful.

TO-DO:
 - Add a secondary AZ as well (Update coming in ~2 days)
 - Secondary public, and private subnets (Update coming in ~2 days)
 - Add a second set of Ubuntu and Windows servers (Update coming in ~2 days)
 - Add an Ansible role that automatically deploys OpenVPN AS to the Public Ubuntu servers to eliminate the need for the user to configure the server. (Update coming in ~7 days) 
 - Add an Ansible role that automatically configures one of the OpenVPN servers as a secondary node (Update coming in ~14 days)

If you have any questions/comments/recommendations please let me know!
