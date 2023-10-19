module aws_network {
  source = "./modules/network"
  create_db_sg = true
  APP_NAME = var.APP_NAME
}

module aws_cluster {
  source = "./modules/cluster"
  cluster_subnet_ids = module.aws_network.public_subnet_id
  depends_on = [ module.aws_network ]
  APP_NAME = var.APP_NAME
}



resource "aws_db_instance" "ra-db" {
  identifier             = "ra-db-instance"
  db_subnet_group_name = module.aws_network.dbsng
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [module.aws_network.db-sg-id]
  username               = "postgres"
  password               = "test1234"
}
