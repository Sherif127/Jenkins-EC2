provider "aws" {
  region = "us-east-1"
  access_key = "ASIASPUGQVRRAUELAEDF"
  secret_key = "3RjCCOTf499pv4nrEZep3sLO+97h9Bx8qej+Qbin"
}

resource "aws_instance" "EC2-Jenkins" {
  ami           = "ami-0953476d60561c955"  
  instance_type = "t2.micro"
  key_name      = "mykey"

  tags = {
    Name = "Jenkins-ec2"
  }
}
