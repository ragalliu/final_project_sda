
resource "aws_vpc" "test" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    Name = "test-ra"
  }
}

resource "aws_subnet" "public_subnet" {
 count = length(var.public_subnets_cidr_blocks)
  vpc_id     = aws_vpc.test.id
  availability_zone = var.availability_zone[count.index]
  cidr_block = var.public_subnets_cidr_blocks[count.index]
  map_public_ip_on_launch = true

}

resource "aws_subnet" "private_subnets" {
       count = length(var.private_subnets_cidr_blocks)
  vpc_id     = aws_vpc.test.id
  cidr_block = var.private_subnets_cidr_blocks[count.index]

  
}

resource "aws_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "igw"
  }
}
resource "aws_route_table" "test" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test.id
  }

  tags = {
    Name = "test-rt"
  }

}

resource "aws_route_table_association" "as" {
 count = length(aws_subnet.public_subnet[*].id)
 subnet_id      = tolist(aws_subnet.public_subnet[*].id)[count.index]
 route_table_id = aws_route_table.test.id

}

resource "aws_security_group" "test" {
  count =var.create_web_ssh_sg ? 1 : 0
  name = "terraform-ra-test"
  vpc_id = aws_vpc.test.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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
resource "aws_security_group" "test_1" {
  count =var.create_db_sg  ? 1 : 0
  name = "terraform-ra-test_1"
  vpc_id = aws_vpc.test.id
  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
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

resource "aws_db_subnet_group" "db_subnet_grp" {
  name = "my_db_sg"
  subnet_ids = aws_subnet.public_subnet[*].id
  tags = {
    Name = "rds_subnet_grp"
  }
  
}
