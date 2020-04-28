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
      "sudo apt update",
      "sudo apt install -y apache2",
      "cat <<EOF > /var/www/html/index.html\n<html><body><h1>Hola Red Server</h1>\n<p>This is Sparta!</p>\n</body></html>"

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
      "sudo apt update",
      "sudo apt install -y apache2",
      "cat <<EOF > /var/www/html/index.html\n<html><body><h1>Hola Green Server</h1>\n<p>This is Sparta!</p>\n</body></html>"
    ]
  }

  tags = merge(local.common_tags, { Name = "${var.env_tag}-web2" })

}


  output "aws_elb_public_dns" {
    value = aws_elb.web.dns_name
  }
