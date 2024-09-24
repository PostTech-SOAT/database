module "sg_rds" {
  source = "../sg"

  vpc_id = var.vpc_id
  description = "modulo de security groups do RDS ${var.rds_name}"
  egress_rules = var.egress_rules
  ingress_rules = var.ingress_rules
  name_tag = var.rds_name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "secret_store" {
  name = "sm-${var.rds_name}-1"
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.secret_store.id
  secret_string = <<EOF
   {
    "username": "${var.db_user}",
    "password": "${random_password.password.result}"
   }
  EOF
  depends_on = [ random_password.password ]
}

resource "aws_db_subnet_group" "this" {
  name       = "subnet-group-${var.application}"
  subnet_ids = var.db_subnet_group_ids

  tags = {
    Name = "subnet-group-${var.application}"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "parameter-group-${var.application}"
  family = var.db_family_group

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "this" {
  allocated_storage    = 10
  db_name              = var.rds_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = "db.t3.micro"
  username             = "hexadmin"
  password             = random_password.password.result
  parameter_group_name = aws_db_parameter_group.this.name
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [module.sg_rds.security_group_id]

  apply_immediately = true
  publicly_accessible = true
  skip_final_snapshot  = true
}

