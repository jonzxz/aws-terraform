resource "aws_iam_role" "ssm_role" {
  name               = "ssm-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Terraform = true
  }
}

resource "aws_iam_policy_attachment" "ssm_attachment_managed_core" {
  name       = "ssm_attachment_managed_core"
  roles      = [aws_iam_role.ssm_role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "ssm_attachment_service_role" {
  name       = "ssm_attachment_service_role"
  roles      = [aws_iam_role.ssm_role.id]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_ec2_instance_profile"
  role = aws_iam_role.ssm_role.id
}
