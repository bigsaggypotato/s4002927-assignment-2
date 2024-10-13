terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 4.0"

    }
  }
}

provider "aws" {
  region = "us-east-1"  
}

resource "aws_security_group" "foo_app_sg" {
  name        = "foo_app_secg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere, use your IP for more security
  }

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to anywhere
  }

  tags = {
    Name = "foo_app_security_group"
  }
}

# Define the EC2 instance to host the Foo app
resource "aws_instance" "foo_app_instance" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t2.micro"  

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.foo_app_secg.id]

  # User data to set up Docker (this will run when the instance is created)
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install docker.io -y
              sudo systemctl start docker
              sudo docker run -d -p 80:80 mattcul/assignment2app
              EOF

  tags = {
    Name = "FooApp-EC2-Instance"
  }

  # Get the public IP address of the instance
  associate_public_ip_address = true
}

# Output the public IP address of the EC2 instance
output "instance_public_ip" {
  value = aws_instance.foo_app_instance.public_ip
  description = "The public IP of the Foo App EC2 instance"
}

# Add Load Balancer and Resiliency
resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_secg.id]
  subnets            = aws_subnet.app_subnets[*].id
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
