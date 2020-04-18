# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: my ebs lab

provider "aws" {
  region = "us-east-1"
}

resource "aws_volume_attachment" "my_ebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.my_block.id
  instance_id = aws_instance.my_vm.id
}

resource "aws_instance" "my_vm" {
  ami               = var.ami
  availability_zone = var.vm_zone
  instance_type     = var.vm_type
  subnet_id         = var.subnet
  key_name          = var.mykey
  
  tags = {
    Name         = "vm-ebs"
  }
}

resource "aws_ebs_volume" "my_block" {
  availability_zone = var.vm_zone
  size              = 100
}