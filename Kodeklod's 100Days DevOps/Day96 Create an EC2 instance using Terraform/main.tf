# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default security group
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# Generate a new RSA key
resource "tls_private_key" "nautilus_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS key pair using the generated public key
resource "aws_key_pair" "nautilus-kp" {
  key_name   = "nautilus-kp"
  public_key = tls_private_key.nautilus_key.public_key_openssh
}

# Launch EC2 instance
resource "aws_instance" "nautilus-ec2" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.nautilus-kp.key_name
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "nautilus-ec2"
  }
}

# Output the private key for SSH access
output "private_key_pem" {
  value     = tls_private_key.nautilus_key.private_key_pem
  sensitive = true
}