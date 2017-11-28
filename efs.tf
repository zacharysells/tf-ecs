resource "aws_efs_file_system" "cluster" {

  tags {
    Name = "${var.env}.ecs"
    Environment = "${var.env}"
  }
}

resource "aws_efs_mount_target" "a" {
  file_system_id = "${aws_efs_file_system.cluster.id}"
  subnet_id      = "${module.vpc.private_subnets[0]}"
  security_groups = [
    "${aws_security_group.allow_all_from_cluster.id}"
  ]
}

resource "aws_efs_mount_target" "b" {
  file_system_id = "${aws_efs_file_system.cluster.id}"
  subnet_id      = "${module.vpc.private_subnets[1]}"
  security_groups = [
    "${aws_security_group.allow_all_from_cluster.id}"
  ]
}

resource "aws_efs_mount_target" "c" {
  file_system_id = "${aws_efs_file_system.cluster.id}"
  subnet_id      = "${module.vpc.private_subnets[2]}"
  security_groups = [
    "${aws_security_group.allow_all_from_cluster.id}"
  ]
}
