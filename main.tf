provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to restrict access (e.g., your IP)
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "app" {
  count         = 2
  ami           = "ami-0ea3c35c5c3284d82" # Update with a valid AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_traffic.name]
  key_name      = "node-app" 
  
  user_data = <<-EOF
              #!/bin/bash
              # Update package index
              sudo apt-get update -y

              # Install Docker
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker $USER

              # Install Node.js 20
              curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
              sudo apt-get install -y nodejs

              # Verify installations
              docker --version
              node -v
              npm -v
              EOF
  
  tags = {
    Name = "NodeApp"
  }
}
