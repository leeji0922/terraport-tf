module "vpc" {
    source = "./modules/vpc"
}

module "ec2" {
    source            = "./modules/ec2"
    
    bastion_subnet_id = module.vpc.aws_public_subnet_id[0]
    vpc_cidr_block    = module.vpc.vpc_cidr_blocks
    vpc_id            = module.vpc.vpc_id
}

#TODO Lambda module call

#TODO api-gateway module call