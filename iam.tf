resource "aws_iam_role" "iam_role" {
  name = "${var.env}-ecs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "efs-policy" {
  name        = "${var.env}-efs-access-policy"
  path        = "/"
  description = "Allow ${var.env} cluster access to EFS"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "elasticfilesystem:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-service-role" {
    role       = "${aws_iam_role.iam_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "ecs-service-for-ec2-role" {
    role       = "${aws_iam_role.iam_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "efs-for-ec2-role" {
    role       = "${aws_iam_role.iam_role.name}"
    policy_arn = "${aws_iam_policy.efs-policy.arn}"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name  = "${var.env}-ecs"
  role = "${aws_iam_role.iam_role.name}"
}