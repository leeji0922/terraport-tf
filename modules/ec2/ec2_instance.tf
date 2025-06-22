#EC2

data "aws_ami" "ami_ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "terraport_bastion" {
  ami                         = data.aws_ami.ami_ubuntu.id
  instance_type               = var.instance_type.bastion
  subnet_id                   = var.bastion_subnet_id
  key_name                    = aws_key_pair.terraport_keypair.key_name
  security_groups             = [aws_security_group.terraport_bastion_sg.id]

  tags = {
    Name = "terraport-bastion"
  }
}