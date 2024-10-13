provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "foo_app_instance" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t2.micro"      # Smallest instance for testing
  tags = {
    Name = "FooApp-Instance"
  }
}

