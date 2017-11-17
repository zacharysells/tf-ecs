module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"

  name = "${var.env}.ecs"

  cidr = "${var.vpc_cidr_first_two}.0.0/16"
  private_subnets = ["${var.vpc_cidr_first_two}.1.0/24", "${var.vpc_cidr_first_two}.2.0/24", "${var.vpc_cidr_first_two}.3.0/24"]
  public_subnets  = ["${var.vpc_cidr_first_two}.101.0/24", "${var.vpc_cidr_first_two}.102.0/24", "${var.vpc_cidr_first_two}.103.0/24"]

  enable_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true

  azs = ["${var.region}a", "${var.region}b", "${var.region}c"]

  tags {
    "Environment" = "${var.env}"
  }
}