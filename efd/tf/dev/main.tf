module "efd" {
    source = "../modules/vpc/"

    #App Variable definitions here (command line arguments override)
    
    #Secrets Below
    
    #Ops Config Values

    vpc_cidr                = var.vpc_cidr
    region                  = var.region
    private_a               = var.private_a
    private_b               = var.private_b
    private_c               = var.private_c
    public_a                = var.public_a
    public_b                = var.public_b
    public_c                = var.public_c
    ingress_access          = var.ingress_access
    ec2_key                 = var.ec2_key 
    instance_size           = var.instance_size
    efd_env                 = var.efd_env
    peer_id                 = var.peer_id
    peer_cidr               = var.peer_cidr

}





provider "aws" {
    region                  = var.region
    profile                 = "efd-dev" 
}
