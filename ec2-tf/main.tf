terraform {
	backend "s3" {
		bucket = "jonny-multi-purpose-bucket"
		key = "multi-purpose-ec2/terraform.tfstate"
	}
}

data "aws_vpc" "default_vpc" {
	id = var.vpc_id
}


data "aws_ami" "amzn_linux2_ami" {
	most_recent = true

	filter {
		name = "name"
		values = ["amzn2-ami-kernel-5.10-hvm-2.0.*"]
	}

	filter {
		name = "virtualization-type"
		values = ["hvm"]
	}

	owners = ["137112412989"]
}

resource "aws_security_group" "basic_sg" {
	name = "allow_simple_tcp"
	description = "Allows HTTP and HTTPS"
	vpc_id = var.vpc_id

	ingress {
		description = "Accept HTTP"
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
	}

	ingress {
		description = "Accept HTTPS"
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Terraform = true
	}
}

resource "aws_instance" "multi-purpose-ec2" {
	ami = data.aws_ami.amzn_linux2_ami.id
	instance_type = "t2.micro"
	security_groups = [aws_security_group.basic_sg.name]
	iam_instance_profile = aws_iam_instance_profile.ssm_profile.id

	tags = {
		Terraform = "true"
	}
}
