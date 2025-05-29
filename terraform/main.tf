provider "aws" {
  region = "us-east-1"
}

# Security Group that allows SSH from anywhere
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-ssh-sg"
  description = "Allow SSH from all IPs"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound
  }
}

# EC2 instance
resource "aws_instance" "EC2-Jenkins" {
  ami           = "ami-0953476d60561c955"
  instance_type = "t2.micro"
  key_name      = "mykey"

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "Jenkins-ec2"
  }
}
