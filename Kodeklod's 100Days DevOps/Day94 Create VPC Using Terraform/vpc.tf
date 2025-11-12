resource "aws_vpc" "devops-vpc" {
    cidr_block = "10.10.0.0/16"
    tags = {
        Name = "devops-vpc"
    }
}