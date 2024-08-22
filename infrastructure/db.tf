resource "aws_security_group" "database" {
  name        = "${var.name}-database"
  description = "Allow traffic to database"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.name}-database"
  }
}

resource "aws_security_group_rule" "allow_bastion" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.database.id
}

resource "aws_security_group_rule" "allow_database_from_vpc" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [module.vpc.vpc_cidr_block]
  security_group_id = aws_security_group.database.id
}

resource "aws_security_group_rule" "allow_database_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.database.id
}

resource "random_pet" "database" {
  length = 1
}

resource "random_password" "database" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  special          = true
  override_special = "*!"
}

resource "aws_db_instance" "database" {
  allocated_storage         = 10
  engine                    = "postgres"
  engine_version            = var.postgres_db_version
  instance_class            = var.db_instance_class
  db_name                   = var.db_name
  identifier                = "${var.name}-${var.db_name}"
  username                  = random_pet.database.id
  password                  = random_password.database.result
  db_subnet_group_name      = module.vpc.database_subnet_group_name
  vpc_security_group_ids    = [aws_security_group.database.id]
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.name}-${var.db_name}"
  storage_encrypted         = true
  copy_tags_to_snapshot     = true
  backup_retention_period   = 7
  multi_az                  = true

  tags = {
    Name = "${var.name}-${var.db_name}"
  }
}