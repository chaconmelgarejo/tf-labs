# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: testing simple tf arch with modules
resource "aws_instance" "my_vm" {
  ami           = var.ami
  instance_type = var.vm_type

  # the VPC subnet
  subnet_id = element(var.public_subnets, 0)

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = aws_key_pair.mykey.key_name

  tags = {
    Name         = "vm-${var.env}"
    Environmnent = var.env
  }
}

resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.my_vpc
  name        = "allow-ssh-${var.env}"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.env
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey-${var.env}"
  public_key = file("${var.path_key}")
}

