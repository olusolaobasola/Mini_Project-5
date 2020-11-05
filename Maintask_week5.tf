provider "aws" {
  version = "~>2.0"
  profile = "default"
  region  = var.region
}

# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "My VPC Week5"
  }
} # end resource

# create the Subnet Private MariaDB
resource "aws_subnet" "My_VPC_Subnet_MariaDB" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock1
  availability_zone       = var.availabilityZone1

  tags = {
    Name = "My VPC Subnet MariaDB"
  }
}

resource "aws_subnet" "My_VPC_Subnet_MariaDB2" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock4
  availability_zone       = var.availabilityZone2

  tags = {
    Name = "My VPC Subnet MariaDB"
  }

} # end resource

resource "aws_db_subnet_group" "mariadb_subnet" {
  name        = "mariadb_subnet"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.My_VPC_Subnet_MariaDB.id,aws_subnet.My_VPC_Subnet_MariaDB2.id]
}



# create the Subnet Public Webserver
resource "aws_subnet" "My_VPC_Subnet_Webserver" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock2
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone2
  tags = {
    Name = "My VPC Subnet Webserver"
  }
} # end resource

# Create the Internet Gateway Public Webserver
resource "aws_internet_gateway" "My_VPC_GW" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My VPC Internet Gateway WS"
  }
} # end resource

# Create the Route Table Public Webserver
resource "aws_route_table" "My_VPC_route_table_WS_RDS" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My VPC Route Table WS RDS"
  }
} # end resource

# Associate the Route Table with the Subnet Public Webserver - RDS
resource "aws_route_table_association" "My_VPC_association1" {
  subnet_id      = aws_subnet.My_VPC_Subnet_Webserver.id
  route_table_id = aws_route_table.My_VPC_route_table_WS_RDS.id
}
# end resource

# Create the Internet Access Public Webserver
resource "aws_route" "My_VPC_internet_access1" {
  route_table_id         = aws_route_table.My_VPC_route_table_WS_RDS.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
}
# end resource


# create the Subnet Public Monitoringserver
resource "aws_subnet" "My_VPC_Subnet_Monitoringserver" {
  vpc_id            = aws_vpc.My_VPC.id
  cidr_block        = var.subnetCIDRblock3
   map_public_ip_on_launch = var.mapPublicIP
  availability_zone = var.availabilityZone3
  tags = {
    Name = "My VPC Subnet Monitoringserver"
  }
} # end resource


# Create the Route Table Public Monitoringserver
resource "aws_route_table" "My_VPC_route_table_WS_Monitoring" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My VPC Route Table WS-MS"
  }
} # end resource

# Associate the Route Table with the Subnet Public Monitoringserver - Webserver
resource "aws_route_table_association" "My_VPC_association2" {
  subnet_id      = aws_subnet.My_VPC_Subnet_Monitoringserver.id
  route_table_id = aws_route_table.My_VPC_route_table_WS_Monitoring.id
}
# end resource

# Create the Internet Access Public Monitoringserver
resource "aws_route" "My_VPC_internet_access2" {
  route_table_id         = aws_route_table.My_VPC_route_table_WS_Monitoring.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
}
# end resource

# Create the Security Group Public Webserver
resource "aws_security_group" "My_VPC_SecurityGroup_Webserver" {
  vpc_id      = aws_vpc.My_VPC.id
  name        = "My VPC SecurityGroup Webserver"
  description = "My VPC SecurityGroup Webserver"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
 
  # allow ingress of port 80

  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # allow egress of all ports 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "My VPC SecurityGroup Webserver"
    Description = "My VPC SecurityGroup Webserver"
  }
} # end resource


# Create the Security Group Private Maria RDS
resource "aws_security_group" "MariaRDS" {
  vpc_id      = aws_vpc.My_VPC.id
  name        = "My VPC SecurityGroup MariaRDS"
  description = "My VPC SecurityGroup MariaRDS"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
 
  # allow ingress of port 3306

  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  # allow egress of all ports 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "My VPC SecurityGroup RDS"
    Description = "My VPC SecurityGroup RDS"
  }
} # end resource


# Create the Security Group Public Monitoringserver
resource "aws_security_group" "My_VPC_SecurityGroup_Monitoringserver" {
  vpc_id      = aws_vpc.My_VPC.id
  name        = "My VPC SecurityGroup Monitoringserver"
  description = "My VPC SecurityGroup Monitoringserver"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # allow ingress of port 80

  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "My VPC SecurityGroup Monitoringserver"
    Description = "My VPC SecurityGroup Monitoringserver"
  }
} # end resource



# Create EC2 instance Public Webserver 1
resource "aws_instance" "webserver_node_1" {
  ami                    = "ami-03bf4f4ea25995de1"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.My_VPC_Subnet_Webserver.id
  key_name               = "DAY 2 HOMEWORK"
  vpc_security_group_ids = [aws_security_group.My_VPC_SecurityGroup_Webserver.id]

  tags = {
    Name        = "WEB BOX 1"
    provisioner = "terraform"
  }
}


# Create EC2 instance Public Webserver 2
resource "aws_instance" "webserver_node_2" {
  ami                    = "ami-03bf4f4ea25995de1"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.My_VPC_Subnet_Monitoringserver.id
  key_name               = "DAY 2 HOMEWORK"
  vpc_security_group_ids = [aws_security_group.My_VPC_SecurityGroup_Monitoringserver.id]

  tags = {
    Name        = "WEB BOX 2"
    provisioner = "terraform"
  }



}


# Create EC2 instance Public Monitoring server Grafana
resource "aws_instance" "grafana_node" {
  ami                    = "ami-0efcfd7c6ab8b5f08"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.My_VPC_Subnet_Monitoringserver.id
  key_name               = "DAY 2 HOMEWORK"
  vpc_security_group_ids = [aws_security_group.My_VPC_SecurityGroup_Monitoringserver.id]

  tags = {
    Name        = "Grafana Box"
    provisioner = "terraform"
  }
}



# Create EC2 instance Private Maria DB
resource "aws_db_instance" "Mariadb_node" {
  allocated_storage       = 20 #GB
  name     = "mariadb"
  port     = "3306"
  engine            = "mariadb"
  engine_version    = "10.4.8"
  instance_class    = "db.t2.micro"
  username = "admin"
  password = "admin123"
  db_subnet_group_name = aws_db_subnet_group.mariadb_subnet.name
  vpc_security_group_ids  = [aws_security_group.MariaRDS.id]
  availability_zone       = aws_subnet.My_VPC_Subnet_MariaDB.availability_zone 

  tags = {
    Name        = "MariaDB Box"

   }

}


output "Webserver_1" {
  value       = aws_instance.webserver_node_1.public_ip
  description = "The ip address of webserver 1 instance."
}

output "Webserver_2" {
  value       = aws_instance.webserver_node_2.public_ip
  description = "The ip address of webserver 2 instance."
}


output "Monitoring_server_Grafana" {
  value       = aws_instance.grafana_node.public_ip
  description = "The ip address of Monitoring server Grafana instance."
}


output "Mariadb_node" {
  value       = aws_db_instance.Mariadb_node.address
  description = "The endpoint of Mariadb_node instance."
}