# main.tf
# 1. Create the VPC
resource "aws_vpc" "xfusion_priv_vpc" {
  cidr_block           = var.KKE_VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "xfusion-priv-vpc"
  }
}

# 2. Create the Private Subnet
resource "aws_subnet" "xfusion_priv_subnet" {
  vpc_id                  = aws_vpc.xfusion_priv_vpc.id
  cidr_block              = var.KKE_SUBNET_CIDR
  # auto-assign IP option must NOT be enabled
  map_public_ip_on_launch = false

  tags = {
    Name = "xfusion-priv-subnet"
  }
}

# 3. Get a public AMI (Amazon Linux 2)
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 4. Create Security Group for EC2
# This SG allows all traffic from within the VPC's CIDR block (10.0.0.0/16)
resource "aws_security_group" "xfusion_priv_sg" {
  name        = "xfusion-priv-sg"
  description = "Allow inbound traffic from within the VPC"
  vpc_id      = aws_vpc.xfusion_priv_vpc.id

  # Ingress Rule: Allow All Protocols/Ports from the VPC CIDR block
  ingress {
    description = "Access from within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols (TCP, UDP, ICMP, etc.)
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  # Egress Rule: Allow All Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "xfusion-priv-sg"
  }
}

# 5. Create the EC2 Instance
resource "aws_instance" "xfusion_priv_ec2" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.xfusion_priv_subnet.id
  # Associate the security group
  vpc_security_group_ids = [aws_security_group.xfusion_priv_sg.id]

  tags = {
    Name = "xfusion-priv-ec2"
  }
}