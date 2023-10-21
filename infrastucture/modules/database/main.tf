resource "aws_db_instance" "ra-db" {
  identifier             = "${var.APP_NAME}-db-instance"
  db_subnet_group_name = var.db-subnet-db_subnet_group_name
  db_name                = var.database_name
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = var.engine_type
  engine_version         = var.engine_ver
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = var.vpc-sg-ids
  username               = var.db_user
  password               = var.db_password
}
