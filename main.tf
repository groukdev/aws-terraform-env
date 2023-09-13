terraform {
  required_version = ">= 1.1.0"
  required_providers {
    aws = ">= 4.0"
  }

  backend "s3" {
    bucket = "groukdev-terraform-state"
    key    = "terraform-env.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile             = "default"
  shared_config_files = ["~/.aws/credentials"]
  region              = "us-east-1"
}

module "ec2-custom" {
  source        = "git@github.com:groukdev/aws-terraform-ec2.git"
  instance_type = "t3.micro"
  instance_name = "WEB"
  user_data     = file("./files/userdata.sh")
  ami           = "ami-05fa00d4c63e32376"
  subnet        = module.vpc-custom.public_subnets
}

module "vpc-custom" {
  source    = "git@github.com:groukdev/aws-terraform-vpc.git"
  vpc_name  = "dev"
  vpc_cidr  = "172.32.0.0/16"
  nat_count = 2
}
