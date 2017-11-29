# README #

## Terraform module to build ECS cluster with EFS storage
With it's default configuration, this terraform module will create an ECS cluster 
with 3 nodes that have an EFS share mounted at `/efs`

This module will also create a bastion host that you can use as a proxy to access your ECS nodes via ssh. Add something like this to your `~/.ssh/config file`.
```
Host 10.15.*
  User ec2-user
  ProxyCommand ssh ec2-user@<basion IP> nc %h %p
```

### Usage
Before using this repo, you will have to have terraform installed. Get the latest version [here](https://www.terraform.io/downloads.html). You will also need to have your AWS access keys configured via environment variables. Documentation to set that up can be found [here](http://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html)

Now that you have all of your dependencies set up, let's get started.

Source this module like so in a .tf file:

```
module ecs {
    source = "github.com/zacharysells/tf-ecs"
    key_name = "my_key"
    env = "dev"
    vpc_cidr_first_two = "10.15"
}
```

Note that there are many other configurable values that you can set for your cluster.
See [variables.tf](variables.tf) for all of them.

```
terraform init
terraform plan
```
This will show you a plan of what changes terraform plans on making when you run the next step. Make sure to review this carefully for any unwanted changes. Note that the `key_name` and `env` variables are required. For descriptions of what these variables and others do, see the [variables.tf](variables.tf) file.

```
terraform apply
```
This will create the actual resources on AWS. This may take some time, and may fail at the very end. This is because sometimes terraform can't resolve resource dependencies correctly, causing a timeout. Simply run the above command again. 

WARNING: Make sure you do NOT delete the `terraform.tfstate` and `terraform.tfstate.backup` files that are created. These are needed to track the state of your resources on AWS. Without them, terraform wont know what has been created and what hasn't. It's a good idea to commit these to source control until backend state stores are set up(https://www.terraform.io/docs/backends/index.html)

### Destroy resources

To destroy your resources, run the same commands as earlier, except replace `apply` with `destroy`. Like the apply command, you may have to run this more than once to actually destroy everything.
