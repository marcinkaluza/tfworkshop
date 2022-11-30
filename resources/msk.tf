resource "aws_security_group" "msk" {
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"  
  name_prefix = "msk_security_group_"
  description = "SG for MSK cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Ingress from VPC CIDR"
    from_port   = 9094
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = [local.cidr_block]
  }
}

module "msk" {
  source             = "../modules/msk"
  cluster_name       = "test"
  subnet_ids         = module.vpc.vpc_private_subnet_ids
  security_group_ids = [aws_security_group.msk.id]
}