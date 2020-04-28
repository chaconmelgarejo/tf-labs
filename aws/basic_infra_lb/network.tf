# tf-labs
# create with good vibes by: @chaconmelgarejo
# description: networking config

resource "aws_vpc" "vpc" {
  cidr_block = var.network_cidr

  tags = merge(local.common_tags, { Name = "${var.env_tag}-net" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, { Name = "${var.env_tag}-igw" })

}

resource "aws_subnet" "subnet1" {
  cidr_block              = var.subnet1_range
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = merge(local.common_tags, { Name = "${var.env_tag}-subnet1" })

}

resource "aws_subnet" "subnet2" {
  cidr_block              = var.subnet2_range
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = merge(local.common_tags, { Name = "${var.env_tag}-subnet2" })

}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, { Name = "${var.env_tag}-rtb" })

}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rta-subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "lb-sg" {
  name   = "service_lb_sg"
  vpc_id = aws_vpc.vpc.id

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.env_tag}-elb" })

}

# Nginx security group
resource "aws_security_group" "service-sg" {
  name   = "service_sg"
  vpc_id = aws_vpc.vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.network_cidr]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.env_tag}-nginx" })

}

resource "aws_lb_target_group" "tg" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "80"
  }

}

resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_lb" "web" {
  name                = "service-lb"
  internal            = false
  #load_balancer_type  = "application"
  subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  security_groups = [aws_security_group.lb-sg.id]
  #instances       = [aws_instance.web1.id,aws_instance.web2.id]

  tags = merge(local.common_tags, { Name = "${var.env_tag}-elb" })

}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}
