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

module "aws_website" {
  source = "./modules/website"
  APP_NAME = var.APP_NAME
  
}

module "aws_db_database" {
  source = "./modules/database"
  APP_NAME = var.APP_NAME
  vpc-sg-ids = [module.aws_network.db-sg-id]
  db-subnet-db_subnet_group_name = module.aws_network.dbsng
  db_user = var.DB_USERNAME
  db_password = var.DB_PASSWORD
  
}

