provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "EC2-Jenkins" {
  ami           = "ami-0953476d60561c955"  
  instance_type = "t2.micro"
  key_name      = "mykey"

  tags = {
    Name = "Jenkins-ec2"
  }
}
