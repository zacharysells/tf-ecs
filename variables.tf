variable "env" {
     description = "Name prefix to associate with each created resource"
}
variable "key_name" {
    description = "The ssh pair to use when creating the instances"
}

variable "vpc_cidr_first_two" {
    description = "First two numbers in the IP CIDR when creating the VPC."
    default = "10.15"
}
variable "region" {
    description = "Region to create cluster in."
    default = "us-east-2"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "min_size" {
    default = "3"
}
variable "max_size" {
    default = "3"
}
variable "desired_size" {
    default = "3"
}
variable "volume_size" {
    default = 80
}

variable "ecs-images" {
  type = "map"
  default = {
    us-east-2 = "ami-1c002379"
    us-east-1 = "ami-9eb4b1e5"
    us-west-2 = "ami-1d668865"
    us-west-1 = "ami-4a2c192a"
    eu-west-2 = "ami-cb1101af"
    eu-west-1 = "ami-8fcc32f6"
    eu-central-1 = "ami-0460cb6b"
    ap-northeast-1 = "ami-b743bed1"
    ap-southeast-2 = "ami-c1a6bda2"
    ap-southeast-1 = "ami-9d1f7efe"
    ca-central-1 = "ami-b677c9d2"
  }
}