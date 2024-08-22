resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.name}-bastion"
  public_key = trimspace(tls_private_key.bastion.public_key_openssh)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "bastion" {
  name        = "${var.name}-bastion"
  description = "Allow traffic to bastion"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.name}-bastion"
  }
}

resource "aws_security_group_rule" "allow_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.client_cidr_blocks
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "allow_bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.bastion.key_name
  user_data                   = file("templates/setup.sh")
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.name}-bastion"
  }
}