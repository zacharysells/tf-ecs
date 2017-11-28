resource "aws_autoscaling_group" "asg" {
  availability_zones        = ["${var.region}a", "${var.region}b", "${var.region}c"]
  name                      = "${var.env}-asg"
  max_size                  = "${var.min_size}"
  min_size                  = "${var.max_size}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = "${var.desired_size}"
  launch_configuration      = "${aws_launch_configuration.alc.name}"
  vpc_zone_identifier       = ["${module.vpc.private_subnets}"]

  tag {
    key                 = "Environment"
    value               = "${var.env}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.env}.ecs"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "alc" {
    name_prefix   = "${var.env}.ecs"
    image_id = "${lookup(var.ecs-images, var.region)}"
    instance_type = "${var.instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.arn}"
    user_data = "${data.template_file.userdata.rendered}"
    key_name = "${var.key_name}"
    security_groups = [
      "${aws_security_group.allow_http_https_from_cluster.id}"
    ]
    lifecycle {
        create_before_destroy = true
    }
    root_block_device {
        volume_type = "gp2"
        volume_size = "${var.volume_size}"
    }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata/ecs-instances.sh")}"

  vars {
    cluster-name = "${aws_ecs_cluster.cluster.name}"
  }
}

resource "aws_instance" "bastion" {
  ami           = "${lookup(var.ecs-images, var.region)}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${module.vpc.public_subnets[0]}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
      "${aws_security_group.allow_ssh_from_all.id}",
      "${aws_security_group.allow_all_from_cluster.id}"
  ]

  tags {
    Environment = "${var.env}"
    Name = "${var.env}.bastion"
  }
}

resource "aws_security_group" "allow_all_from_cluster" {
  name        = "${var.env}-allow-from-cluster"
  description = "Allow traffic from cluster"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self = true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh_from_all" {
  name        = "allow_ssl_from_all"
  description = "Allow ssh traffic"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}