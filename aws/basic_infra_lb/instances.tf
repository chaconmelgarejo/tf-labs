# tf-labs
# create with good vibes by: @chaconmelgarejo
# description: instances config


provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web1" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.vm_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.service-sg.id]
  key_name               = var.key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install nginx -y",
      "sudo service nginx start"
    ]

  }

  tags = merge(local.common_tags, { Name = "${var.env_tag}-web1" })

}

resource "aws_instance" "web2" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.vm_type
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.service-sg.id]
  key_name               = var.key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt install nginx -y",
      "sudo service nginx start"
    ]
  }

  tags = merge(local.common_tags, { Name = "${var.env_tag}-web2" })

}


  output "aws_lb_public_dns" {
    value = aws_lb.web.dns_name
  }
