# resource "aws_vpc" "prod" {
#     provider = aws.naveen
#   cidr_block = var.cidr_block_1
#   enable_dns_hostnames = true
#   tags = {
#     Name = "${var.vpc_names}"
#   }  

# }

# resource "aws_internet_gateway" "igws" {
#     provider = aws.naveen
#     vpc_id = aws_vpc.prod.id
#     tags = {
#         "Name" = "${var.vpc_names}-igw"
#     }

# }

# resource "aws_subnet" "publics" {
#     provider = aws.naveen
#     count = 3
#     vpc_id = aws_vpc.prod.id
#     cidr_block = element(var.cidr_block_publics,count.index)
#     availability_zone = element(var.azs1,count.index)
#     map_public_ip_on_launch = true
#     tags = {
#         Name = "${var.vpc_names}-public${count.index+1}"
#     }

# }
# resource "aws_route_table" "rt1" {
#     provider = aws.naveen
#     vpc_id = aws_vpc.prod.id
#     route {
#         gateway_id = aws_internet_gateway.igws.id
#         cidr_block = "0.0.0.0/0"
#     }
#   tags = {
#     Name = "${var.vpc_names}-rt"
#   }
# }

# resource "aws_route_table_association" "associate1" {
#     provider = aws.naveen
#     count = 3
# route_table_id = aws_route_table.rt1.id
# subnet_id = element(aws_subnet.publics.*.id,count.index)

# }

# resource "aws_route" "communication1" {
#     provider = aws.naveen
#     route_table_id = aws_route_table.rt1.id
#     destination_cidr_block = var.cidr_block
#     vpc_peering_connection_id = aws_vpc_peering_connection.owner.id


# }

# resource "aws_security_group" "sg1" {
#     provider = aws.naveen
#     vpc_id = aws_vpc.prod.id
#     name = "prod-group"
#     description = "allow all rules"
#     tags = {
#         Name = "${var.vpc_names}-sg"

#     }
#     ingress {
#         to_port = 0
#         from_port = 0
#         protocol = -1
#         cidr_blocks = ["0.0.0.0/0"]
#     }  
#     egress {
#         to_port = 0
#         from_port = 0
#         protocol = -1
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }

# resource "aws_instance" "server1" {
#     provider = aws.naveen
#     count =1
#     ami = var.ami1
#     instance_type = var.instance_type1
#     key_name = var.key_name1
#     vpc_security_group_ids = [aws_security_group.sg1.id]
#     subnet_id = element(aws_subnet.publics.*.id,count.index)
#     private_ip = element(var.private_ips,count.index)
#     associate_public_ip_address = true
#     user_data = <<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install apache2 -y
#     sudo systemctl start apache2
#     EOF
# tags = {
#     Name = "${var.vpc_names}-server${count.index+1}"
# }

#     }

